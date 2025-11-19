//
//  Navigation.swift
//  team11BC
//
//  Created by Aimee Zheng on 2025/11/10.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = FirebaseViewModel()
    
    
    @State private var selectedTab = 0
    
    let primaryBlue: Color = Color(red: 0.0, green: 0.47, blue: 1.0)
    
    var body: some View {
        TabView {
            // Inventory (Home) Page
            NavigationView {
                InventoryView(viewModel: viewModel)
                    .navigationTitle("Inventory")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Inventory", systemImage: "square.grid.2x2")
            }
            .tag(0)
            
            // Report Lost Item Page
            NavigationView {
                ReportLostView(viewModel: viewModel)
                    .navigationTitle("Report Lost")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Report Lost", systemImage: "exclamationmark.triangle")
            }
            .tag(1)
           
            NavigationView {
                ReportFoundView(viewModel: viewModel)
                    .navigationTitle("Report Found")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Report Found", systemImage: "hand.raised.fill")
            }
            .tag(2)
            

        }
        .tint(primaryBlue)
    }
}

#Preview {
    MainTabView()
}
