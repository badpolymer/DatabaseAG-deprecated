//
//  Item.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/27/22.
//

import Foundation

class MainItem {
    var familyPN: String {
        var prefix : String {return (self.prefixes.isEmpty ? "" : "()") + (self.prefixPN ?? "")}
        var midfix : String {return self.midfixes.isEmpty ? "" : "()"}
        var mainfix : String {return self.mainfixes.isEmpty ? "" : "()"}
        var suffix: String {return (self.suffix ?? "") + (self.suffixes.isEmpty ? "" : "()")}
        return prefix + midfix + self.mainPN + mainfix + suffix
    }
   
    var prefixes: [ModifiableSection] = []
    var prefixPN: String?
    var midfixes: [ModifiableSection] = []
    var mainPN: String
    var mainfixes: [ModifiableSection] = []
    var suffix: String?
    var suffixes : [ModifiableSection] = []
    
    init(mainPN: String, name:String) {
        self.mainPN = mainPN
        self.itemName = name
    }
    
    var itemName : String
    
    
    
}



class ModifiableSection {
    var fixes: [String]?
}
