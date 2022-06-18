//
//  MainController.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

class MainController : ObservableObject {
    var rootItems = RootCategory.items
    var rootManagerIsSelected : Bool = false {
        didSet {
            if rootManagerIsSelected {
                self.selectedMainCat = nil
                self.selectedMainItem = nil
            }
        }
    }
    @Published var selectedMainCat: MainCategory?
    @Published var selectedSUbCat: SubCategory?
    @Published var selectedMainItem : MainItem?
    
    
    
 //MARK: - <#Section Heading#>
//    var rootItems = [main_Tool,main_Connector,main_Contact,main_Terminal,main_Wire,main_Splice,main_Accessory]
    
}
