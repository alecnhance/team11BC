//
//  ContentView.swift
//  team11BC
//
//  Created by Alec Hance on 11/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    
    private var primaryBlue = Color(red: 0.0, green: 0.47, blue: 1.0)
    private var backgroundBlue = Color(red: 39.0 / 255.0, green: 76.0 / 255.0, blue: 119.0 / 255.0)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        backgroundBlue,
                        backgroundBlue.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // App Icon/Title Section
                    VStack(spacing: 24) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                        
                        Text("Lost and Found")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Connect items with their owners")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 80)
                    
                    Spacer()
                    
                    // Continue Button
                    NavigationLink(destination: MainTabView()) {
                        Text("Continue as Guest")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
}

// Custom button style for press animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
