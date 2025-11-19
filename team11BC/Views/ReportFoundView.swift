//
//  ItemFound.swift
//  team11BC
//
//  Created by Smitha Pasumarti on 11/10/25.
//
import SwiftUI
import PhotosUI
//import GoogleGenerativeAI

struct ReportFoundView: View {
    let viewModel: FirebaseViewModel
    @State private var selectedCategory: Category = .none
    @State private var description: String = ""
    @State private var contactInfo: String = ""
    @State private var location: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: UIImage? = nil
    @State private var editingItem: FoundItem?
    @State private var isEditing: Bool = false
    //@State private var viewModel = FoundItemsViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 39/255, green: 76/255, blue: 119/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Report a Found Item")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Category")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Picker("Select a category", selection: $selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                if category == Category.none {
                                    Text("          ").tag(category)
                                } else {
                                    Text(category.rawValue).tag(category)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                        .cornerRadius(10)
                        
                        Text("Description of Item")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                            .cornerRadius(10)
                        
                        Text("Location Found")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextField("Enter where you found the item", text: $location)
                            .padding()
                            .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                            .cornerRadius(10)
                        
                        Text("Contact Details")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextField("Enter your email or phone", text: $contactInfo)
                            .padding()
                            .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                            .cornerRadius(10)
                        
                        Text("Image (Optional)")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Select Image")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                            .cornerRadius(10)
                        }
                        .onChange(of: selectedPhoto) { oldValue, newItem in
                            guard let newItem else { return }

                                Task {
                                    do {
                                        if let data = try await newItem.loadTransferable(type: Data.self) {
                                            handleImageChosen(data)
                                        }
                                    } catch {
                                        print("Error loading image: \(error)")
                                    }
                                }
                        }
                        
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(12)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: { handleSubmit() }) {
                        Text(isEditing ? "Save Changes" : "Submit")
                            .foregroundColor(Color(red: 39/255, green: 76/255, blue: 119/255))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    .disabled(selectedCategory == .none || description.isEmpty || contactInfo.isEmpty)
                    .opacity((selectedCategory == .none || description.isEmpty || contactInfo.isEmpty) ? 0.5 : 1.0)
                    
                    if !viewModel.foundItems.isEmpty {
                        Text("Reported Items")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.foundItems) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    if let urlString = item.imageURL, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 120)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 120)
                                                    .cornerRadius(10)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 120)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }

                                    Text(item.category.rawValue)
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Location: \(item.location)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Text("Contact: \(item.contact)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    HStack {
                                        Button("Edit") { startEditing(item) }
                                            .foregroundColor(.blue)
                                        Button("Delete") { deleteItem(item) }
                                            .foregroundColor(.red)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding()
                                .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .alert(isEditing ? "Item Updated Successfully" : "Item Successfully Reported", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(isEditing ? "Your item details have been updated." : "The misplaced item has been submitted.")
        }
//        .navigationTitle("Inventory Tracker")
    }
    
    private func handleSubmit() {
        guard selectedCategory != .none,
              !description.isEmpty,
              !contactInfo.isEmpty else { return }

        Task {
            // Create the new item with imageURL nil; the URL will be set after upload
            let newItem = FoundItem(
                category: selectedCategory,
                description: description,
                imageURL: nil, // URL will be set after uploading
                location: location,
                contact: contactInfo
            )

            // Pass the image data separately for upload
            viewModel.addFoundItem(newItem, imageData: selectedImageData) { error in
                if let error = error {
                    print("Failed to add item: \(error)")
                    showAlert = true
                } else {
                    // reset form
                    selectedCategory = .none
                    description = ""
                    location = ""
                    contactInfo = ""
                    selectedImageData = nil
                    selectedImage = nil
                    isEditing = false
                    showAlert = true
                }
            }
        }
    }
    
    
    
    private func deleteItem(_ item: FoundItem) {
        viewModel.deleteFoundItem(item) { error in
            if let error = error { print("Error deleting item: \(error)") }
        }
    }
    
    private func startEditing(_ item: FoundItem) {
        selectedCategory = item.category
        description = item.description
        location = item.location
        contactInfo = item.contact
        editingItem = item
        isEditing = true
        
        // Optional: load image from URL for preview
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    await MainActor.run {
                        self.selectedImageData = data
                        self.selectedImage = UIImage(data: data)
                    }
                } catch {
                    print("Failed to load image for editing: \(error)")
                    await MainActor.run {
                        self.selectedImageData = nil
                        self.selectedImage = nil
                    }
                }
            }
        } else {
            selectedImageData = nil
            selectedImage = nil
        }
    }
    
    func handleImageChosen(_ data: Data) {
        Task {
            await MainActor.run {
                self.selectedImageData = data
                self.selectedImage = UIImage(data: data)
                // Generate Image Description
                /*
                if description == "" {
                    self.description = "Generating description..."
                }
                 */
            }

            // Generate Image Description
            /*
            let compressed = UIImage(data: data)?.jpegData(compressionQuality: 0.5)

            guard let compressed else { return }

            let generated = await generateDescriptionFromImageData(compressed)

            await MainActor.run {
                self.description = generated
            }
             */
        }
    }
    
/*
    func generateDescriptionFromImageData(_ data: Data) async -> String {
        let model = GenerativeModel(name: "gemini-pro-vision", apiKey: "YOUR GEMINI API KEY")
        
        do {
            let response = try await model.generateContent([
                        ModelContent(role: "user", parts: [
                            .text("Describe the item in this photo."),
                            .data(mimetype: "image/jpeg", data)
                        ])
                    ])

            return response.text ?? "No description generated."
            
        } catch {
            print("Gemini ERROR:", error)
            return "Error generating description."
        }
    }
 */
    }

#Preview {
    ReportFoundView(viewModel: FirebaseViewModel())
}
