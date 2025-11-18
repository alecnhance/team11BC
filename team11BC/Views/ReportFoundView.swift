//
//  ItemFound.swift
//  team11BC
//
//  Created by Smitha Pasumarti on 11/10/25.
//

import SwiftUI
import PhotosUI

struct ReportFoundView: View {
    @State private var selectedCategory: Category = .none
    @State private var description: String = ""
    @State private var contactInfo: String = ""
    @State private var location: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @State private var editingItem: FoundItem?
    @State private var isEditing: Bool = false
    
    @State private var viewModel = FoundItemsViewModel()
    

    var body: some View {
        ZStack {
            Color(red: 39/255, green: 76/255, blue: 119/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Report Found Item")
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
                                Text(category.rawValue).tag(category)
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
                        .onChange(of: selectedPhoto) { oldValue, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(12)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        handleSubmit()
                    }) {
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
                                    if let data = item.image,
                                       let img = UIImage(data: data) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                            .cornerRadius(10)
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
                                        Button("Edit") {
                                            startEditing(item)
                                        }
                                        .foregroundColor(.blue)
                                        
                                        Button("Delete") {
                                            deleteItem(item)
                                        }
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
        .alert(isEditing ? "Item Updated Successfully" : "Item Successfully Reported",
               isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(isEditing ? "Your item details have been updated." : "Your lost item has been submitted.")
        }
        .navigationTitle("Inventory Tracker")
    }
    
    private func handleSubmit() {
        let newItem = FoundItem(
            category: selectedCategory,
            description: description,
            image: selectedImageData,
            location: location,
            contact: contactInfo
        )
        
        if isEditing, let editingItem = editingItem,
           let index = viewModel.foundItems.firstIndex(where: { $0.id == editingItem.id }) {
            viewModel.foundItems[index] = newItem
            isEditing = false
        } else {
            viewModel.foundItems.append(newItem)
        }
        selectedCategory = .none
        description = ""
        location = ""
        contactInfo = ""
        selectedImageData = nil
        showAlert = true
    }
    
    private func deleteItem(_ item: FoundItem) {
        withAnimation {
            viewModel.foundItems.removeAll { $0.id == item.id }
        }
    }
    
    private func startEditing(_ item: FoundItem) {
        selectedCategory = item.category
        description = item.description
        location = item.location
        contactInfo = item.contact
        selectedImageData = item.image
        
        editingItem = item
        isEditing = true
    }
}

#Preview {
    ReportFoundView()
}
