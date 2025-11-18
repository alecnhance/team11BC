//
//  LostAndFoundView.swift
//  team11BC
//
//  Created by Ilisha Gupta on 10/11/25.

import SwiftUI

struct LostItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var contact: String
}

struct ReportLostView: View {
    @State private var itemName = ""
    @State private var description = ""
    @State private var contactInfo = ""
    @State private var showAlert = false
    @State private var lostItems: [LostItem] = []
    
    @State private var editingItem: LostItem?
    @State private var isEditing = false

    var body: some View {
        ZStack {
            Color(red: 39/255, green: 76/255, blue: 119/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Lost and Found")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("Item Name")
                                .foregroundColor(.white)
                                .font(.headline)
                            TextField("Enter the item you lost", text: $itemName)
                                .padding()
                                .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                                .cornerRadius(10)
                            
                            Text("Description")
                                .foregroundColor(.white)
                                .font(.headline)
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                                .cornerRadius(10)
                            
                            Text("Contact Details")
                                .foregroundColor(.white)
                                .font(.headline)
                            TextField("Enter your email or phone", text: $contactInfo)
                                .padding()
                                .background(Color(red: 231/255, green: 236/255, blue: 239/255))
                                .cornerRadius(10)
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
                    
                    if !lostItems.isEmpty {
                        Text("Reported Items")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        VStack(spacing: 12) {
                            ForEach(lostItems) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Contact: \(item.contact)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Button("Edit") {
                                            startEditing(item)
                                        }
                                        .foregroundColor(.blue)
                                        
                                        Button("Resolve") {
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
        .navigationTitle("Report Lost")
    }
    
    private func handleSubmit() {
        if isEditing, let editingItem = editingItem {
            if let index = lostItems.firstIndex(where: { $0.id == editingItem.id }) {
                lostItems[index] = LostItem(name: itemName, description: description, contact: contactInfo)
            }
            isEditing = false
        } else {
            let newItem = LostItem(name: itemName, description: description, contact: contactInfo)
            lostItems.append(newItem)
        }
        itemName = ""
        description = ""
        contactInfo = ""
        showAlert = true
    }
    
    private func deleteItem(_ item: LostItem) {
        withAnimation {
            lostItems.removeAll { $0.id == item.id }
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
    ReportLostView()
}
