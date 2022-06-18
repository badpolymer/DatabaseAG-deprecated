//
//  MainController.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI
import RealmSwift

class MainController : ObservableObject {
    var myrealm: Realm?
    
    lazy var rootItems = myrealm?.objects(MainCategory.self)
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
    
    func loadRealm() {
        var config = Realm.Configuration.defaultConfiguration
        
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose single directory"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            if let result = dialog.url {
                config.fileURL = result
                myrealm = try! Realm(configuration: config)
            }
        }else{
            return
        }
    }
    
    
}
