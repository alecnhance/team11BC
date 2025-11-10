//
//  InventoryView.swift
//  team11BC
//
//  Created by Yada Phongadulyasook on 11/3/25.
//

import SwiftUI


/*
 Colors:
 Dark Blue: 39, 76, 119
 Middle Blue: 96, 150, 186
 Light Blue: 163, 206, 241
 Nearly White Blue: 231, 236, 239
 Middle Grey: 139, 140, 137

 */




struct InventoryView: View {
    
    @State private var viewModel = FoundItemsViewModel()
    @State private var selectedItem: FoundItem? = nil
    @State private var selectedCategory: Category = Category.none
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Items Found")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color(red: 39/255, green: 76/255, blue: 119/255))
                Menu {
                    ForEach (Category.allCases, id: \.self) { category in
                        Button(category.rawValue) {
                            selectedCategory = category
                        }
                    }
                } label: {
                    Label(selectedCategory.rawValue, systemImage: "chevron.down")
                        .padding()
                        .background(Color(red: 96/255, green: 150/255, blue: 186/255))
                        .cornerRadius(8)
                        .foregroundStyle(Color(red: 255/255, green: 255/255, blue: 255/255))
                        .font(.system(size: 20))
                }
            
                
                
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.foundItems) { item in
                            
                            if selectedCategory == .none || item.category == selectedCategory {
                                Button {
                                    selectedItem = item
                                } label: {
                                    FoundItemCard(item: item)
                                }
                            }
                            
                        }
                    }
                    .padding()
                }
                .sheet(item: $selectedItem) { item in
                    FoundItemDetailView(item: item)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }.navigationTitle("InventoryView")
    }
    
}

struct FoundItemCard: View {
    let item: FoundItem
    
    var body: some View {
        VStack {
            Text(item.category.rawValue)
                .font(.title)
                .foregroundStyle(Color(red: 255/255, green: 255/255, blue: 255/255))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Spacer()
            
            GeometryReader { geo in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: UIScreen.main.bounds.height * 0.30)
                    .clipped()
            }
            .frame(width: UIScreen.main.bounds.width * 0.625, height: UIScreen.main.bounds.height * 0.25)
             .cornerRadius(8)
            
            Spacer()
            Text(item.location)
                .font(.title3)
                .foregroundStyle(Color(red: 231/255, green: 236/255, blue: 239/255))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .italic()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.925)
        .background(Color(red: 39/255, green: 76/255, blue: 119/255))
        .cornerRadius(12)
        .shadow(radius: 0)
    }
}

struct FoundItemDetailView: View {
    let item: FoundItem
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item.category.rawValue)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color(red: 0.1529, green: 0.2980, blue: 0.4667))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .cornerRadius(10)
                Spacer(minLength: UIScreen.main.bounds.width * 0.10)
                Text("Description:")
                    .foregroundStyle(Color(red: 0.1529, green: 0.2980, blue: 0.4667))
                    .font(.system(size: 19.5))
                Text(item.description)
                    .font(.system(size: 19.5))
                    .foregroundStyle(Color(red: 0.1529, green: 0.2980, blue: 0.4667))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer(minLength: UIScreen.main.bounds.width * 0.075)
                Text("Last Location:")
                    .font(.system(size: 19.5))
                    .foregroundStyle(Color(red: 0.1529, green: 0.2980, blue: 0.4667))
                Text(item.location)
                    .font(.system(size: 19.5))
                    .foregroundStyle(Color(red: 0.1529, green: 0.2980, blue: 0.4667))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding()
        }
    }
    
}

#Preview {
    InventoryView()
}
