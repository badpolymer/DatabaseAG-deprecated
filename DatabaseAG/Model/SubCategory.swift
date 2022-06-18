//
//  SubCategory.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import Foundation

class SubCategory : Identifiable {
    let id = UUID()
    var name : String
//    var mainCategory : MainCategory
    var items : Array<MainItem>?
    
    init(name: String) {
        self.name = name
    }
}



var subcat_Bolt = SubCategory(name: "Bolt")
var subcat_Nut = SubCategory(name: "Nut")
var subcat_FRC = SubCategory(name: "Front Release Connector")


protocol Family {
    var familyPN : String { get set }
}
