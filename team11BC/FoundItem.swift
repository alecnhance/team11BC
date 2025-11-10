//
//  FoundItem.swift
//  team11BC
//
//  Created by Yada Phongadulyasook on 11/3/25.
//

import Foundation
import SwiftUI

struct FoundItem: Identifiable {
    let id = UUID()
    var category: Category
    var description: String
    var image: String
    var location: String
    var contact: String
}

enum Category: String, CaseIterable {
    case none = "View All"
    case waterBottle = "Water Bottle"
    case electronic = "Electronic"
    case bag = "Bag"
    
    var id: String {
        self.rawValue
    }
}
