//
//  FoundItemsViewModel.swift
//  team11BC
//
//  Created by Yada Phongadulyasook on 11/3/25.
//

import Foundation
import SwiftUI

@Observable class FoundItemsViewModel {
    var foundItems: [FoundItem] = [
        FoundItem(category: Category.waterBottle, description: "White water bottle with a red stripe and skull on the side and smiley face sticker on top", image: "waterbottle", location: "Next to Skiles Walkway"),
        FoundItem(category: Category.electronic, description: "MacBook Air with a smiley face sticker", image: "macbook", location: "At Kaldi's Coffee"),
        FoundItem(category: Category.bag, description: "Black backpack from North Face with a labubu in front", image: "backpack", location: "Come get it from me at NAV scan-in counter."),
        FoundItem(category: Category.electronic, description: "iPad with a sticker of Tech Tower, and a black case", image: "ipad", location: "At Klaus 1116W")
    ]
}
 //try catch block - if no pic - then something else
