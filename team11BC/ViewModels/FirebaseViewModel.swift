import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

@Observable class FirebaseViewModel {
    var foundItems: [FoundItem] = []
    var lostItems: [LostItem] = []
    var isLoading = false
    var errorMessage: String?

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    init() {
        print("🟢 FirebaseViewModel initialized")
        print("🟢 Firebase app configured: \(FirebaseApp.app() != nil)")
        fetchFoundItems()
        fetchLostItems()
    }

    // MARK: - Fetch Found Items
    func fetchFoundItems() {
        isLoading = true
        db.collection("foundItems")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error fetching found items: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No found items")
                    return
                }
                
                self.foundItems = documents.compactMap { doc in
                    let data = doc.data()
                    guard let categoryStr = data["category"] as? String,
                          let category = Category(rawValue: categoryStr),
                          let description = data["description"] as? String,
                          let location = data["location"] as? String,
                          let contact = data["contact"] as? String else { return nil }
                    
                    let imageUrl = data["imageUrl"] as? String
                    
                    return FoundItem(
                        category: category,
                        description: description,
                        imageURL: imageUrl, // <-- store URL instead of Data
                        location: location,
                        contact: contact
                    )
                }
            }
    }

    // MARK: - Add Found Item
    func addFoundItem(_ item: FoundItem, imageData: Data?, completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("foundItems").document()
        
        if let data = imageData {
            // Upload image to Firebase Storage
            uploadImage(data) { [weak self] result in
                switch result {
                case .success(let imageUrl):
                    // Save item with image URL
                    self?.saveFoundItemToFirestore(item, imageUrl: imageUrl, documentId: docRef.documentID, completion: completion)
                case .failure(let error):
                    print("Image upload failed: \(error)")
                    completion(error)
                }
            }
        } else {
            // Save item without image
            saveFoundItemToFirestore(item, imageUrl: nil, documentId: docRef.documentID, completion: completion)
        }
    }

    // MARK: - Save Item to Firestore
    private func saveFoundItemToFirestore(_ item: FoundItem, imageUrl: String?, documentId: String, completion: @escaping (Error?) -> Void) {
        var data: [String: Any] = [
            "category": item.category.rawValue,
            "description": item.description,
            "location": item.location,
            "contact": item.contact,
            "timestamp": Timestamp(date: Date())
        ]
        if let imageUrl { data["imageUrl"] = imageUrl }

        db.collection("foundItems").document(documentId).setData(data) { error in
            if let error = error {
                print("Error adding found item: \(error)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    
    func updateFoundItem(_ item: FoundItem, completion: @escaping (Error?) -> Void) {
        // For updates, you'd need to store the document ID in FoundItem
        // For now, this is a placeholder implementation
        completion(nil)
    }

    func deleteFoundItem(_ item: FoundItem, completion: @escaping (Error?) -> Void) {
        // You'll need to add a documentId field to FoundItem to make this work
        // For now, find by matching all fields
        db.collection("foundItems")
            .whereField("category", isEqualTo: item.category.rawValue)
            .whereField("description", isEqualTo: item.description)
            .whereField("location", isEqualTo: item.location)
            .getDocuments { snapshot, error in
                if let error = error { completion(error); return }
                guard let document = snapshot?.documents.first else {
                    completion(NSError(domain: "FirebaseViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"]))
                    return
                }
                document.reference.delete { error in
                    completion(error)
                }
            }
    }

    // MARK: - Lost Items
    func fetchLostItems() {
        isLoading = true
        db.collection("lostItems")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error fetching lost items: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No lost items")
                    return
                }
                self.lostItems = documents.compactMap { doc in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let description = data["description"] as? String,
                          let contact = data["contact"] as? String else { return nil }
                    return LostItem(
                        name: name,
                        description: description,
                        contact: contact
                    )
                }
            }
    }

    func addLostItem(_ item: LostItem, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "name": item.name,
            "description": item.description,
            "contact": item.contact,
            "timestamp": Timestamp(date: Date())
        ]
        db.collection("lostItems").addDocument(data: data) { error in
            if let error = error {
                print("Error adding lost item: \(error)")
            }
            completion(error)
        }
    }

    func updateLostItem(_ item: LostItem, completion: @escaping (Error?) -> Void) {
        // Similar to updateFoundItem, needs document ID
        completion(nil)
    }

    func deleteLostItem(_ item: LostItem, completion: @escaping (Error?) -> Void) {
        db.collection("lostItems")
            .whereField("name", isEqualTo: item.name)
            .whereField("description", isEqualTo: item.description)
            .whereField("contact", isEqualTo: item.contact)
            .getDocuments { snapshot, error in
                if let error = error { completion(error); return }
                guard let document = snapshot?.documents.first else {
                    completion(NSError(domain: "FirebaseViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"]))
                    return
                }
                document.reference.delete { error in
                    completion(error)
                }
            }
    }

    // MARK: - Image Upload
    private func uploadImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let filename = UUID().uuidString
        let ref = storage.reference().child("found_items/\(filename).jpg")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error { completion(.failure(error)); return }
            ref.downloadURL { url, error in
                if let error = error { completion(.failure(error)); return }
                if let urlString = url?.absoluteString {
                    completion(.success(urlString))
                } else {
                    completion(.failure(NSError(domain: "FirebaseViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
}

