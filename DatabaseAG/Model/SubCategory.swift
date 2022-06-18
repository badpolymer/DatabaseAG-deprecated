//
//  SubCategory.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import Foundation
import RealmSwift

class SubCategory : Object, Identifiable {
    @Persisted var id = ObjectId()
    @Persisted var name : String = "Not defined subCat"
    @Persisted(originProperty: "subCategories") var mainCategory: LinkingObjects<MainCategory>
    @Persisted var items : List<MainItem>
    
}


