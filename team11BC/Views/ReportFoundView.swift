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
    
    let primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    let backgroundColor = Color(.systemGroupedBackground)
    let cardBackground = Color(.systemBackground)
    
    var body: some View {
        ScrollView {
                  VStack(spacing: 24) {
                      // Form Section
                      VStack(spacing: 20) {
                          // Category
                          VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                                  .font(.system(size: 17, weight: .semibold))
                                  .foregroundColor(Color(.label))
                        
                        Picker("Select a category", selection: $selectedCategory) {
                            ForEach(Category.allCases.filter { $0 != .none }, id: \.self) { category in
                                if category == Category.none {
                                    Text("          ").tag(category)
                                } else {
                                    Text(category.rawValue).tag(category)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(primaryBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(.label))
                        
                        ZStack(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Describe the item you found...")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                            }
                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                                .scrollContentBackground(.hidden)
                                .padding(4)
                        }
                        .padding(8)
                        .background(cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Location Found")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(.label))
                        
                        TextField("Enter where you found the item", text: $location)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(cardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                    
                    // Contact Details
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Contact Details")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(.label))
                        TextField("Enter your email or phone", text: $contactInfo)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(cardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                    
                    // Image Picker
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Image (Optional)")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(.label))
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            HStack(spacing: 12) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 18))
                                    .foregroundColor(primaryBlue)
                                Text(selectedImageData == nil ? "Select Image" : "Change Image")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(.label))
                                Spacer()
                                if selectedImageData != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(cardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
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
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                                .padding(.top, 8)
                        }
                    }
                    
                      }
                      .padding(.horizontal, 16)
                      .padding(.top, 16)
                    
                      // Submit Button
                      Button(action: {
                          handleSubmit()
                      }) {
                          Text(isEditing ? "Save Changes" : "Submit")
                              .font(.system(size: 17, weight: .semibold))
                              .foregroundColor(.white)
                              .frame(maxWidth: .infinity)
                              .frame(height: 50)
                              .background(primaryBlue)
                              .cornerRadius(12)
                              .shadow(color: primaryBlue.opacity(0.3), radius: 8, y: 4)
                      }
                      .padding(.horizontal, 16)
                      .disabled(selectedCategory == .none || description.isEmpty || contactInfo.isEmpty)
                      .opacity((selectedCategory == .none || description.isEmpty || contactInfo.isEmpty) ? 0.5 : 1.0)
                      .buttonStyle(ScaleButtonStyle())
                      
                      // Reported Items Section
                      if !viewModel.foundItems.isEmpty {
                          VStack(alignment: .leading, spacing: 16) {
                              Text("Your Reported Items")
                                  .font(.system(size: 22, weight: .bold))
                                  .foregroundColor(Color(.label))
                                  .padding(.horizontal, 16)
                        
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
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 150)
                                                    .clipped()
                                                    .cornerRadius(12, corners: [.topLeft, .topRight])
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 150)
                                                    .clipped()
                                                    .cornerRadius(12, corners: [.topLeft, .topRight])
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 8) {
                                                                            HStack {
                                                                                Text(item.category.rawValue)
                                                                                    .font(.system(size: 16, weight: .semibold))
                                                                                    .foregroundColor(primaryBlue)
                                                                                    .padding(.horizontal, 10)
                                                                                    .padding(.vertical, 4)
                                                                                    .background(primaryBlue.opacity(0.1))
                                                                                    .cornerRadius(8)
                                                                                Spacer()
                                        }
                                            
                                        Text(item.description)
                                            .font(.system(size: 15))
                                            .foregroundColor(Color(.label))
                                            .lineLimit(2)
                                        
                                        HStack(spacing: 16) {
                                            Label(item.location, systemImage: "location.fill")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(.secondaryLabel))
                                            
                                            Label(item.contact, systemImage: "phone.fill")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(.secondaryLabel))
                                        }
                                    
                                        HStack(spacing: 16) {
                                            Button {
                                                startEditing(item)
                                            } label: {
                                                HStack(spacing: 6) {
                                                    Image(systemName: "pencil")
                                                    Text("Edit")
                                                }
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(primaryBlue)
                                            }
                                            
                                            Button {
                                                deleteItem(item)
                                            } label: {
                                                HStack(spacing: 6) {
                                                    Image(systemName: "trash")
                                                    Text("Delete")
                                                }
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.red)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 4)
                                    }
                                    .padding(16)
                                }
                                .background(cardBackground)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(backgroundColor)
        .alert(isEditing ? "Item Updated Successfully" : "Item Successfully Reported", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(isEditing ? "Your item details have been updated." : "The misplaced item has been submitted.")
        }
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
     let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "YOUR_ACTUAL_API_KEY_HERE")
     
     do {
         let response = try await model.generateContent([
             ModelContent(role: "user", parts: [
                 .text("Describe this lost or found item briefly. Focus on identifying features like color, type, brand, and condition."),
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

// Helper extension for corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ReportFoundView(viewModel: FirebaseViewModel())
}
