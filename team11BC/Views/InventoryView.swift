//
//  InventoryView.swift
//  team11BC
//
//  Created by Yada Phongadulyasook on 11/3/25.
//

import SwiftUI

struct InventoryView: View {
    
    @StateObject private var viewModel = FoundItemsViewModel()
    @State private var selectedFoundItem: FoundItem? = nil
    @State private var selectedLostItem: [String]? = nil
    @State private var selectedCategory: Category = Category.none
    @State private var selectedLostFound: Int = 0
    @State private var foundItemSheet: Bool = true
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    private var backgroundColor = Color(.systemGroupedBackground)
    private var cardBackground = Color(.systemBackground)
    
    let itemsOption = ["View All", "Found Items", "Lost Items"]
    
    let lostItems = [
        ["Water Bottle", "blue with a butterfly sticket", "please call me at 1234567890"],
        ["Laptop", "macbook pro with a red case and many stickets on it", "something@gatech.edu"],
        ["Hoodie", "black hoodie with a red graphic in front, from uniqlo, size M", "9876543210"]
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Section
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Menu {
                            ForEach(0...2, id: \.self) { i in
                                Button(itemsOption[i]) {
                                    selectedLostFound = i
                                    if (selectedLostFound != 1) {
                                        selectedCategory = Category.none
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(itemsOption[selectedLostFound])
                                    .font(.system(size: 16, weight: .medium))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(cardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        }
                        
                        if (selectedLostFound == 1) {
                            Menu {
                                ForEach (Category.allCases.filter { $0 != .none }, id: \.self) { category in
                                    Button(category.rawValue) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory == .none ? "All Categories" : selectedCategory.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(primaryBlue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .background(backgroundColor)
  
                // Items List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.foundItems) { item in
                            if ( selectedLostFound != 2 && (selectedCategory == .none || item.category == selectedCategory)) {
                                Button {
                                    foundItemSheet = true
                                    selectedFoundItem = item
                                } label: {
                                    FoundItemCard(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        ForEach(0...2, id: \.self) { i in
                            if ( selectedLostFound != 1) {
                                Button {
                                    foundItemSheet = false
                                    selectedLostItem = lostItems[i]
                                } label: {
                                    LostItemCard(item: lostItems[i])
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .background(backgroundColor)
            }
            .background(backgroundColor)
            .sheet(isPresented: Binding(
                get: { selectedFoundItem != nil || selectedLostItem != nil },
                set: { newValue in
                    if !newValue {
                        selectedFoundItem = nil
                        selectedLostItem = nil
                    }
                }
            )) {
                NavigationView {
                    if foundItemSheet, let item = selectedFoundItem {
                        FoundItemDetailView(item: item)
                    } else if let item = selectedLostItem {
                        LostItemDetailView(item: item)
                    }
                }
            }
        }
    }
}


struct FoundItemCard: View {
    let item: FoundItem
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    private var cardBackground = Color(.systemBackground)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            Group {
                if let data = item.image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } else {
                    ZStack {
                        Color(.systemGray5)
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(Color(.systemGray3))
                    }
                    .frame(height: 200)
                }
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 12) {
                // Category Badge
                HStack {
                    Text(item.category.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(primaryBlue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                }
                
                // Location
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.secondaryLabel))
                    Text(item.location)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(.label))
                }
                
                // Description Preview
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.secondaryLabel))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
        }
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
    }
}

struct LostItemCard: View {
    let item: [String]
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    private var cardBackground = Color(.systemBackground)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            
            // Item Name
            Text(item[0])
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(.label))
                .multilineTextAlignment(.leading)
            
            // Description
            Text(item[1])
                .font(.system(size: 15))
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            
            // Contact Info
            HStack(spacing: 6) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.secondaryLabel))
                Text("Contact Available")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
    }
}

struct LostItemDetailView: View {
    let item: [String]
    
    @Environment(\.dismiss) private var dismiss
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                            Text("LOST ITEM")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                    
                    Text(item[0])
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(.label))
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Description Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(.label))
                    
                    Text(item[1])
                        .font(.system(size: 17))
                        .foregroundColor(Color(.secondaryLabel))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Contact Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contact Information")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(.label))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 18))
                            .foregroundColor(primaryBlue)
                        
                        Text(item[2])
                            .font(.system(size: 17))
                            .foregroundColor(Color(.label))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(primaryBlue)
            }
        }
    }
}

struct FoundItemDetailView: View {
    let item: FoundItem
    
    @Environment(\.dismiss) private var dismiss
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
       
       
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.category.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(primaryBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(primaryBlue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    
                    Text(item.category.rawValue)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(.label))
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Image
                Group {
                    if let data = item.image, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                    } else {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "photo")
                                .font(.system(size: 64))
                                .foregroundColor(Color(.systemGray3))
                        }
                        .frame(height: 300)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Description Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(.label))
                    
                    Text(item.description)
                        .font(.system(size: 17))
                        .foregroundColor(Color(.secondaryLabel))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Location Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Location Found")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(.label))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(primaryBlue)
                        
                        Text(item.location)
                            .font(.system(size: 17))
                            .foregroundColor(Color(.label))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(primaryBlue)
            }
        }
    }
}

#Preview {
    InventoryView()
}

