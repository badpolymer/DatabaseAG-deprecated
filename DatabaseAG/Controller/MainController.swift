//
//  MainController.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI
import RealmSwift

class MainController : ObservableObject {
    static var myrealm: Realm?
    @Published var filePath : String?
    @Published var mainCategories : Results<MainCategory>?
    
    @Published var rootManagerIsSelected : Bool = true {
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
    
    @Published var dataChangeIsComplete : Bool = false
    
    // MARK: - Realm DataBase
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
                config.fileURL!.appendPathComponent("default")
                config.fileURL!.appendPathExtension("realm")

                do{
                    MainController.myrealm = try Realm(configuration: config)
                    filePath = MainController.myrealm!.configuration.fileURL?.absoluteString
                    mainCategories = MainController.myrealm!.objects(MainCategory.self)
                } catch {
                    realmError(error)
                }
                
            }
        }else{
            return
        }
    }
    
    func realmError(_ e : Error){
        let alert = NSAlert()
        alert.messageText = "Realm related Error"
        alert.informativeText = e.localizedDescription
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    
    func realmIsLoaded() -> Bool {
        if MainController.myrealm == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Root Manager (Main Categories)
    func addMainCat(name n : String, symbol s : String) {
        dataChangeIsComplete = false
        let trimedName = n.trimmingCharacters(in: .whitespaces)
        var trimedSymbol = s.trimmingCharacters(in: .whitespaces)
        if trimedSymbol == "" { trimedSymbol = "questionmark.square.dashed"}
        if let currentMainCats = mainCategories {
            var duplicateNames : Int = 0
            for category in currentMainCats {
                if trimedName.compare(category.name, options: .caseInsensitive) == .orderedSame {
                    duplicateNames += 1
                }
            }
            
            if duplicateNames == 0 {
                let newMainCat = MainCategory(name: trimedName, image: trimedSymbol)
                
                    do {
                        try MainController.myrealm?.write{
                            MainController.myrealm?.add(newMainCat)
                            self.dataChangeIsComplete = true
                            
                        }
                        
                    } catch {
                        self.realmError(error)
                    }
                
            } else {
                mainCatEditingError("\(trimedName) already exists.")
            }
        }
        
        
    }
    
    func updateMainCat(_ m: MainCategory, name n: String, symbol s:String) {
        dataChangeIsComplete = false
        if realmIsLoaded() {
            
                try! MainController.myrealm?.write{
                    m.name = n
                    m.image = s
                }
            
            dataChangeIsComplete = true
        }
    }
    
    
    func deleteMainCat(_ itemToDelete: MainCategory){
        dataChangeIsComplete = false
        if realmIsLoaded() && mainCategories != nil {
            
            let subItemsNumber = itemToDelete.subCategories.count
            if subItemsNumber == 0 {
                
                let alert = NSAlert()
                alert.messageText = "Deletioin"
                alert.informativeText = "Note: There is no item under this category. Make sure to remove it?"
                alert.addButton(withTitle: "Cancel")
                alert.addButton(withTitle: "Yes")
                alert.alertStyle = .warning
                let result = alert.runModal()
                switch result {
                case NSApplication.ModalResponse.alertFirstButtonReturn:
                    print("First (and usually default) button")
                case NSApplication.ModalResponse.alertSecondButtonReturn:
                    DispatchQueue.main.async {
                        do {
                            try MainController.myrealm?.write{
                                MainController.myrealm?.delete(itemToDelete)
                            }
                        } catch {
                            self.realmError(error)
                        }
                    }
                default:
                    print("There is no provision for further buttons")
                }
                
            } else {
                self.mainCatEditingError("There is still items under this category. You cannot delete it.")
            }
              
        } else {
            self.mainCatEditingError("Datebase is not loaded or there is no item in root.")
        }
    }
    
    func mainCatEditingError(_ text :String){
        let alert = NSAlert()
        alert.messageText = "Operation Error"
        alert.informativeText = text
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    

    
    
    
    
    
}
