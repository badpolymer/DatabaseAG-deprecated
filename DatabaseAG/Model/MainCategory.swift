//
//  MainCategory.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import Foundation
import RealmSwift

class MainCategory :Object,Identifiable{
    @Persisted var id = UUID()
    @Persisted var name: String = "Not Delfined"
    @Persisted var image: String = "questionmark.square.dashed"
    @Persisted var subCategories: List<SubCategory>
    
    
    convenience init(name: String, image: String) {
        self.init()
        self.name = name
        self.image = image
    }
}








