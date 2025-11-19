//
//  LostAndFoundView.swift
//  team11BC
//
//  Created by Ilisha Gupta on 10/11/25.

import SwiftUI

struct ReportLostView: View {
    let viewModel: FirebaseViewModel
    
    let primaryBlue: Color = Color(red: 0.0, green: 0.47, blue: 1.0)
    let backgroundColor: Color = Color(.systemGroupedBackground)
    let cardBackground: Color = Color(.systemBackground)
    
    @State private var itemName = ""
    @State private var description = ""
    @State private var contactInfo = ""
    @State private var showAlert = false
    @State private var lostItems: [LostItem] = []
    @State private var editingItem: LostItem?
    @State private var isEditing = false

    
    var body: some View {
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 20) {
                        //item name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item Name")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(.label))
                            
                            TextField("Enter the item you lost", text: $itemName)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
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
                                    Text("Describe the item you lost...")
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
                    .disabled(itemName.isEmpty || description.isEmpty || contactInfo.isEmpty)
                    .opacity((itemName.isEmpty || description.isEmpty || contactInfo.isEmpty) ? 0.5 : 1.0)
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Reported Items Section
                    if !viewModel.lostItems.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Reported Items")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(.label))
                                .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.lostItems) { item in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Lost Badge
                                    
                                    HStack {
                                        HStack(spacing: 6) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 12))
                                            Text("LOST")
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                        .foregroundColor(.orange)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.orange.opacity(0.15))
                                        .cornerRadius(8)

                                        Spacer()
                                    }
                                                               .padding(.horizontal, 16)
                                                               .padding(.top, 16)
                                                               
                                                               VStack(alignment: .leading, spacing: 8) {
                                                                   Text(item.name)
                                                                       .font(.system(size: 20, weight: .semibold))
                                                                       .foregroundColor(Color(.label))
                                                                   
                                                                   Text(item.description)
                                                                       .font(.system(size: 15))
                                                                       .foregroundColor(Color(.secondaryLabel))
                                                                       .lineLimit(3)
                                                                   
                                                                   HStack(spacing: 12) {
                                                                       Label(item.contact, systemImage: "phone.fill")
                                                                           .font(.system(size: 13))
                                                                           .foregroundColor(Color(.secondaryLabel))
                                                                   }
                                                                   .padding(.top, 4)
                                                               
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
                                                                               Image(systemName: "checkmark.circle")
                                                                               Text("Resolve")
                                                                           }
                                                                           .font(.system(size: 15, weight: .medium))
                                                                           .foregroundColor(.green)
                                                                       }
                                                                       
                                                                       Spacer()
                                        }
                                        .padding(.top, 8)
                                    }
                                                               .padding(.horizontal, 16)
                                                               .padding(.bottom, 16)
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
            Text(isEditing ? "Your item details have been updated." : "Your lost item has been submitted.")
        }
    }
    
    private func handleSubmit() {
        if isEditing, let editingItem = editingItem {
            if let index = lostItems.firstIndex(where: { $0.id == editingItem.id }) {
                lostItems[index] = LostItem(name: itemName, description: description, contact: contactInfo)
            }
            isEditing = false
        } else {
            let newItem = LostItem(name: itemName, description: description, contact: contactInfo)
            viewModel.addLostItem(newItem) { error in
                if error != nil {
                    //show error alert
                    self.showAlert = true
                } else {
                    //clear form on success
                    itemName = ""
                    description = ""
                    contactInfo = ""
                    showAlert = true
                }
            }
        }
    }
    
    private func deleteItem(_ item: LostItem) {
        withAnimation {
            viewModel.deleteLostItem(item) { error in
                if let error = error { print("Error in deleting item: \(error)")}
                
            }
        }
    }
        
    private func startEditing(_ item: LostItem) {
        itemName = item.name
        description = item.description
        contactInfo = item.contact
        editingItem = item
        isEditing = true
    }
    
}

#Preview {
    ReportLostView(viewModel: FirebaseViewModel())
}
