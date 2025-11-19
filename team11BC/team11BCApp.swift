//
//  team11BCApp.swift
//  team11BC
//
//  Created by Alec Hance on 11/3/25.
//

//import SwiftUI
//import FirebaseCore
//@main
//struct team11BCApp: App {
//    init() {
//        FirebaseApp.configure()
//    }
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct team11BCApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {

                ContentView()
        }
    }
}
