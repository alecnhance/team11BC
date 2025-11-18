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
    @State private var selectedFoundItem: FoundItem? = nil
    @State private var selectedLostItem: [String]? = nil
    @State private var selectedCategory: Category = Category.none
    @State private var selectedLostFound: Int = 0
    @State private var foundItemSheet: Bool = true
    
    let itemsFoundColor = Color(red: 255/255, green: 255/255, blue: 255/255)
    let backgroundColor = Color(red: 9/255, green: 9/255, blue: 93/255)
    let catButtonBGColor = Color(red: 26/255, green: 26/255, blue: 174/255)
    let catButtonFGColor = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    let itemsOption = ["View All", "Found Items", "Lost Items"]
    
    let lostItems = [
        ["Water Bottle", "blue with a butterfly sticket", "please call me at 1234567890"],
        ["Laptop", "macbook pro with a red case and many stickets on it", "something@gatech.edu"],
        ["Hoodie", "black hoodie with a red graphic in front, from uniqlo, size M", "9876543210"]
    ]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Items Collection")
                    .font(.largeTitle.bold())
                    .foregroundStyle(itemsFoundColor)
                HStack {
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
                        Label(itemsOption[selectedLostFound], systemImage: "chevron.down")
                            .padding()
                            .background(catButtonBGColor)
                            .cornerRadius(5)
                            .foregroundStyle(catButtonFGColor)
                            .font(.system(size: 20))
                    }
                    if (selectedLostFound == 1) {
                        Menu {
                            ForEach (Category.allCases, id: \.self) { category in
                                Button(category.rawValue) {
                                    selectedCategory = category
                                }
                            }
                        } label: {
                            Label(selectedCategory.rawValue, systemImage: "chevron.down")
                                .padding()
                                .background(catButtonBGColor)
                                .cornerRadius(5)
                                .foregroundStyle(catButtonFGColor)
                                .font(.system(size: 20))
                        }
                    }
                }
  
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.foundItems) { item in
                                        
                            if ( selectedLostFound != 2 && (selectedCategory == .none || item.category == selectedCategory)) {
                                Button {
                                    foundItemSheet = true
                                    selectedFoundItem = item
                                } label: {
                                    FoundItemCard(item: item)
                                }
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
                            }
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: Binding(
                    get: { selectedFoundItem != nil || selectedLostItem != nil },
                    set: { newValue in
                        if !newValue {
                            selectedFoundItem = nil
                            selectedLostItem = nil
                        }
                    }
                )) {
                    if foundItemSheet, let item = selectedFoundItem {
                        FoundItemDetailView(item: item)
                    } else if let item = selectedLostItem {
                        LostItemDetailView(item: item)
                    }
                }
                            
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }.navigationTitle("InventoryView")
    }
    //menu is first lost/found items -> if chose found items -> categories picker
    
}


struct FoundItemCard: View {
    let item: FoundItem
    
    let BGColor = Color(red: 163/255, green: 206/255, blue: 241/255)
    let titleColor = Color(red: 39/255, green: 76/255, blue: 119/255)
    let locaColor = Color(red: 96/255, green: 150/255, blue: 186/255)
       
    
    var body: some View {
        VStack {
            Text(item.category.rawValue)
                .font(.title)
                .foregroundStyle(titleColor)
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
                .foregroundStyle(locaColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .italic()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.925)
        .background(BGColor)
        .cornerRadius(12)
        .shadow(radius: 0)
    }
}

struct LostItemCard: View {
    let item: [String]
    
    let BGColor = Color(red: 163/255, green: 206/255, blue: 241/255)
    let titleColor = Color(red: 39/255, green: 76/255, blue: 119/255)
    let locaColor = Color(red: 96/255, green: 150/255, blue: 186/255)
    
    var body: some View {
        VStack {
            Text(item[0])
                .font(.title)
                .foregroundStyle(titleColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Spacer()
            Text(item[1])
                .font(.title3)
                .foregroundStyle(locaColor)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .italic()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.925)
        .background(BGColor)
        .cornerRadius(12)
        .shadow(radius: 0)
    }
    
}

struct LostItemDetailView: View {
    let item: [String]
    
    let BGColor = Color(red: 255/255, green: 255/255, blue: 255/255)
    let titleColor = Color(red: 39/255, green: 76/255, blue: 119/255)
    let bodyColor = Color(red: 39/255, green: 76/255, blue: 119/255)
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item[0])
                    .font(.title)
                    .bold()
                    .foregroundStyle(titleColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer(minLength: UIScreen.main.bounds.height*0.08)
                Text("Description:")
                    .foregroundStyle(bodyColor)
                    .font(.system(size: 19.5))
                Text(item[1])
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer(minLength: UIScreen.main.bounds.height*0.08)
                Text("Contact Information:")
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                Text(item[2])
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding()
            .background(BGColor)
        }
    }
}

struct FoundItemDetailView: View {
    let item: FoundItem
    
    let BGColor = Color(red: 255/255, green: 255/255, blue: 255/255)
    let titleColor = Color(red: 39/255, green: 76/255, blue: 119/255)
    let bodyColor = Color(red: 39/255, green: 76/255, blue: 119/255)
       
       
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item.category.rawValue)
                    .font(.title)
                    .bold()
                    .foregroundStyle(titleColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .cornerRadius(10)
                Spacer(minLength: UIScreen.main.bounds.width * 0.10)
                Text("Description:")
                    .foregroundStyle(bodyColor)
                    .font(.system(size: 19.5))
                Text(item.description)
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer(minLength: UIScreen.main.bounds.width * 0.075)
                Text("Last Location:")
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                Text(item.location)
                    .font(.system(size: 19.5))
                    .foregroundStyle(bodyColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding()
            .background(BGColor)
        }
    }
}

#Preview {
    InventoryView()
}
