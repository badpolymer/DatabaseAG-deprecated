//
//  MainCategory.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import Foundation
import SwiftUI

class MainCategory :Identifiable, ObservableObject {
    let id = UUID()
    dynamic var name: String = ""
    var image: Image
    var subCategories : [SubCategory]?
    
    init(name: String, image:Image, subCategories : [SubCategory]? ) {
        self.name = name
        self.image = image
        self.subCategories = subCategories
    }
}








