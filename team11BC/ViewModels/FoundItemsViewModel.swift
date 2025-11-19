//
//  FoundItemsViewModel().swift
//  team11BC
//
//  Created by Smitha Pasumarti on 11/10/25.
//

import Foundation
import SwiftUI

class FoundItemsViewModel: ObservableObject {
    @Published var foundItems: [FoundItem] = [
        FoundItem(category: .waterBottle, description: "White water bottle with a red stripe and skull on the side and sxmiley face sticker on top", image: UIImage(named: "waterbottle")?.pngData(), location: "Next to Skiles Walkway", contact: "1234567890"),
        FoundItem(category: .electronic, description: "MacBook Air with a smiley face sticker", image: UIImage(named: "macbook")?.pngData(), location: "At Kaldi's Coffee", contact: "123@gmail.com"),
        FoundItem(category: .bag, description: "Black backpack from North Face with a labubu in front", image: UIImage(named: "backpack")?.pngData(), location: "Come get it from me at NAV scan-in counter.", contact: "4045931277"),
        FoundItem(category: .electronic, description: "iPad with a sticker of Tech Tower, and a black case", image: UIImage(named: "ipad")?.pngData(), location: "At Klaus 1116W", contact: "test@gmail.com")
    ]
}
