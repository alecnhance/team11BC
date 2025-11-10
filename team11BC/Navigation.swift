//
//  Navigation.swift
//  team11BC
//
//  Created by Aimee Zheng on 2025/11/10.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Inventory (Home) Page
            NavigationView {
                InventoryView()
                    .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Inventory")
            }.tint(.blue)
            
            // Report Lost Item Page
            NavigationView {
                LostAndFoundView()
                    .navigationTitle("Report Lost")
            }
            .tabItem {
                Image(systemName: "exclamationmark.bubble")
                Text("Report Lost")
            }.tint(.blue)
           
            NavigationView {
                ReportFoundView()
                    .navigationTitle("Report Found Item")
            }
            .tabItem {
                Image(systemName: "doc.richtext")
                Text("Report Found")
            }.tint(.blue)
            
            
//            // Bounty Page
//            NavigationView {
//                Text("Bounty Page")
//                    .navigationTitle("Bounties")
//            }
//            .tabItem {
//                Image(systemName: "doc.richtext")
//                Text("Bounties")
//            }.tint(.blue)
        }
    }
}

#Preview {
    MainTabView()
}
