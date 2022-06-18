//
//  RootCategory.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import Foundation
import RealmSwift

class RootCategory : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String?
    @Persisted var mainCategories: List<MainCategory>
}

