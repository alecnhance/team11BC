//
//  Navigation.swift
//  team11BC
//
//  Created by Aimee Zheng on 2025/11/10.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = FirebaseViewModel()
    
    var body: some View {
        TabView {
            // Inventory (Home) Page
            NavigationView {
                InventoryView(viewModel: viewModel)
//                    .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Inventory")
            }.tint(.blue)
            
            // Report Lost Item Page
            NavigationView {
                ReportLostView(viewModel: viewModel)
//                    .navigationTitle("Report Lost")
            }
            .tabItem {
                Image(systemName: "exclamationmark.bubble")
                Text("Report Lost")
            }.tint(.blue)
           
            NavigationView {
                ReportFoundView(viewModel: viewModel)
//                    .navigationTitle("Report Found")
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
        }/*.tint(.black).toolbarBackground(Color.blue, for: .tabBar)*/
            .onAppear {
                    UITabBar.appearance().backgroundColor = .lightGray
                }
    }
}

#Preview {
    MainTabView()
}
