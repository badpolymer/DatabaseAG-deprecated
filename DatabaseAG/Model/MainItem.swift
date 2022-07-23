//
//  Item.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/27/22.
//

import Foundation
import RealmSwift

class MainItem : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    var familyPN: String {
        var prefix : String {return (self.prefixes.isEmpty ? "" : "()") + (self.prefixPN ?? "")}
        var midfix : String {return self.midfixes.isEmpty ? "" : "()"}
        var mainfix : String {return self.mainfixes.isEmpty ? "" : "()"}
        var suffix: String {return (self.suffix ?? "") + (self.suffixes.isEmpty ? "" : "()")}
        return prefix + midfix + self.mainPN! + mainfix + suffix
    }
   
    var prefixes: [ModifiableSection] = []
    @Persisted var prefixPN: String?
    var midfixes: [ModifiableSection] = []
    @Persisted var mainPN: String?
    var mainfixes: [ModifiableSection] = []
    @Persisted var suffix: String?
    var suffixes : [ModifiableSection] = []
    
//    init(mainPN: String, name:String) {
//        self.mainPN = mainPN
//        self.itemName = name
//    }
    
    var itemName : String?
    
    
    @Persisted(originProperty: "items") var category : LinkingObjects<SubCategory>
}



class ModifiableSection {
    var fixes: [String]?
}
