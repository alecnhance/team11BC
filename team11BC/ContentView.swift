//
//  ContentView.swift
//  team11BC
//
//  Created by Alec Hance on 11/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 39.0 / 255.0, green: 76.0 / 255.0, blue: 119.0 / 255.0)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Lost and Found App")
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .padding(.bottom, 60)
                    
                    NavigationLink(destination: InventoryView()) {
                        Text("View lost and found inventory")
                            .foregroundColor(.black)
                            .font(.body)
                            .padding()
                            .background(Color(red: 0.0 / 0.0, green: 0.0 / 0.0, blue: 239.0 / 255.0))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                    
                    NavigationLink(destination: LostAndFoundView()) {
                        Text("Report a lost item")
                            .foregroundColor(.black)
                            .font(.body)
                            .padding()
                            .background(Color(red: 0.0 / 0.0, green: 0.0 / 0.0, blue: 239.0 / 255.0))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                    
                    NavigationLink(destination: ReportFoundView()) {
                        Text("Report a found item")
                            .foregroundColor(.black)
                            .font(.body)
                            .padding()
                            .background(Color(red: 0.0 / 0.0, green: 0.0 / 0.0, blue: 239.0 / 255.0))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Main View")
    }
}

#Preview {
    ContentView()
}
