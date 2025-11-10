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
                HStack{
                    Text("Lost and Found App")
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 100)
                        .font(.title)
                }
                NavigationLink(destination: InventoryTracker()) {
                    Text("Continue as a guest")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
        }.navigationTitle("Main View")
    }
}
#Preview {
    ContentView()
}
