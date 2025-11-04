//
//  FoundItem.swift
//  team11BC
//
//  Created by Yada Phongadulyasook on 11/3/25.
//

import Foundation

struct FoundItem: Identifiable {
    var id: UUID = UUID()
    var category: Category
    var description: String
    var image: String
    var location: String
}

enum Category: String, CaseIterable {
    case none = "View All"
    case waterBottle = "Water Bottle"
    case electronic = "Electronic"
    case bag = "Bag"
}

