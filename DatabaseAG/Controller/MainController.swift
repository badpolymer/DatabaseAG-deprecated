//
//  MainController.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI
import RealmSwift

class MainController : ObservableObject {
    private var myrealm: Realm?
    @Published var filePath : String?
    @Published var mainCategories : [MainCategory]?
    @Published var rootManagerIsSelected : Bool = true {
        didSet {
            if rootManagerIsSelected {
                startObservingMainCategoriesChange()
                self.selectedMainCat = nil
                self.selectedMainItem = nil
            } else {
                stopObservingMainCategoriesChange()
            }
        }
    }
    //Change Listeners
    private var mainCategoriesChangeListener: NotificationToken?
    
    //SubCatlist
    @Published var subCategories : [SubCategory]?
    @Published var selectedMainCat: MainCategory?
    @Published var mainCategoryManagerIsEditing = false
    @Published var shownSubCategories : Results<SubCategory>?
    
    @Published var selectedSubCat: SubCategory?
    @Published var selectedMainItem : MainItem?
    
    @Published var operationIsComplete : Bool = false
    
    
    
    func reloadSubCat() {
        if let selectedMainCat = selectedMainCat {
            shownSubCategories = myrealm?.objects(SubCategory.self)
            shownSubCategories = shownSubCategories!.where{$0.mainCategory == selectedMainCat}
            print (shownSubCategories?.description ?? "NNNNNNNNNNNNNNNNNNNN")
            
        }
    }
    // MARK: - Collection Change Listeners
    func startObservingMainCategoriesChange() {
        if let database = myrealm {
            let results = database.objects(MainCategory.self)
            
            mainCategoriesChangeListener = results.observe { [weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    print("ObservingMainCategoriesChange")
                case .update(_, let deletions, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    print(" Delete at index: ",deletions,"\n","Insert at index: ", insertions, "\n","modify at index: ", modifications)
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    self?.reloadMainCategories()
                    
                    
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                }
            }
        }
    }
    
    func stopObservingMainCategoriesChange() {
        mainCategoriesChangeListener?.invalidate()
        print("stopObservingMainCategoriesChange")
    }
    // MARK: - Realm DataBase Loading
    func loadRealm() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 2
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
                    myrealm = try Realm(configuration: config)
                    filePath = myrealm!.configuration.fileURL?.absoluteString
                    mainCategories = Array(myrealm!.objects(MainCategory.self))
                    self.startObservingMainCategoriesChange()
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
        if myrealm == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Realm CRUD Method
    private func add(_ object: Object){
        self.operationIsComplete = false
        if let database = myrealm {
            do {
                try database.write({
                    database.add(object)
                    self.operationIsComplete = true
                })
            } catch {
                realmError(error)
            }
        } else {
            errorAlert(with: "Database is not loaded.(Object Creation)")
        }
    }
    
    private func deleteFromDatabase(_ object: Object) {
        self.operationIsComplete = false
        if let database = myrealm {
            do {
                try database.write({
                    database.delete(object)
                    self.operationIsComplete = true
                })
            } catch {
                realmError(error)
            }
        } else {
            errorAlert(with: "Database is not loaded.(Object Deletion)")
        }
    }
    
    func delete(_ object: Object) {
        switch object {
        case is MainCategory:
            let mainCategory = object as! MainCategory
            let subCategoryNumber = mainCategory.subCategories.count
            if subCategoryNumber > 0 {
                errorAlert(with: "There is one or more subcategory in this Category. You cannot remove it.")
            } else {
                deleteWithAlert(mainCategory)
            }
            
        case is SubCategory:
            let subCategory = object as! SubCategory
            let itemNumber = subCategory.items.count
            if itemNumber > 0 {
                errorAlert(with: "There is one or more item in this Category. You cannot remove it.")
            } else {
                deleteWithAlert(subCategory)
            }
            
        default:
            print("Default")
        }
    }
    
    private func deleteWithAlert(_ itemToDelete: Object) {
        let alert = NSAlert()
        alert.messageText = "Warning"
        alert.informativeText = "Are you sure to remove it?"
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        let result = alert.runModal()
        switch result {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            print("First (and usually default) button")
        case NSApplication.ModalResponse.alertSecondButtonReturn:
            deleteFromDatabase(itemToDelete)
        default:
            print("There is no provision for further buttons")
        }
    }
    
    // MARK: - Root Manager (Main Categories)
    func updateOrAddMainCat(_ mainCat: MainCategory?, newName n: String, newSymbol s : String) {
        operationIsComplete = false
        if let database = myrealm {
            let trimedName = n.trimmingCharacters(in: .whitespaces)
            var trimedSymbol = s.trimmingCharacters(in: .whitespaces)
            if trimedSymbol == "" { trimedSymbol = "questionmark.square.dashed"}
            if trimedName.count != 0 {
                if let editingCategory = mainCat {
                    // Editing existing Category
                    if countDuplicationInMainCategories(by: trimedName) > 1 {
                        errorAlert(with: "\(trimedName) already exists. Code: 1")
                    } else if countDuplicationInMainCategories(by: trimedName) == 1 {
                        let duplicate = database.objects(MainCategory.self).where({$0.name == trimedName}).first?.id
                        if editingCategory.id != duplicate {
                            print(editingCategory)
                            print(duplicate as Any)
                            errorAlert(with: "\(trimedName) already exists. Code: 2")
                        } else {
                            //Not duplicated
                            updateMainCat(editingCategory, trimedName, trimedSymbol)
                        }
                    } else {
                        //Not duplicated
                        updateMainCat(editingCategory, trimedName, trimedSymbol)
                    }
                } else {
                    // Add New Category
                    if countDuplicationInMainCategories(by: trimedName) > 0 {
                        errorAlert(with: "\(trimedName) already exists. Code: 3")
                    } else {
                        let newCategory = MainCategory(name: trimedName, image: trimedSymbol)
                        add(newCategory)
                    }
                }
            } else {
                errorAlert(with: "The name of category cannot be empty. Code:1")
            }
        } else {
            errorAlert(with: "Database is not loaded.(Root Manager)")
        }
    }
    
    private func countDuplicationInMainCategories(by name: String) -> Int {
        if let existingCategories = myrealm?.objects(MainCategory.self).where({$0.name == name}) {
            return existingCategories.count
        } else {
            return 0
        }
    }
    
    private func updateMainCat(_ m: MainCategory, _ n: String, _ s: String ) {
        do {
            try myrealm?.write{
                m.name = n
                m.image = s
            }
            operationIsComplete = true
        } catch {
            realmError(error)
        }
    }
    
    // MARK: - Subcategory List(Main Category Manager)
    func reloadSubCategories(under mainCategory: MainCategory?) {
        if let category = mainCategory, let datebase = myrealm {
            let subcategories = Array(datebase.objects(SubCategory.self).where{$0.mainCategory == category})
            self.subCategories = subcategories
        } else {
            subCategories = nil
        }
    }
    
    // MARK: - Content View Control
    func errorAlert(with text :String){
        let alert = NSAlert()
        alert.messageText = "Operation Error"
        alert.informativeText = text
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    private func reloadMainCategories() {
        mainCategories = Array(myrealm!.objects(MainCategory.self))
    }
    
    func convert(_ id:UUID?) -> SubCategory? {
        if let id = id, let mainCategories = selectedMainCat {
            let result = mainCategories.subCategories.where{$0.id == id}
            return result.first
        } else {
            return nil
        }
        
    }
    
    func add(_ subCategory: String) {
        if let mainCategory = selectedMainCat {
            do {
                try myrealm?.write({
                    let newCategory = SubCategory()
                    newCategory.name = subCategory
                    mainCategory.subCategories.append(newCategory)
                })
            } catch {
                realmError(error)
            }
        }
    }
    
    func modify(_ nameOfsubCategory: String) {
        if let selectedSubCat = selectedSubCat {
            do {
                try myrealm?.write({
                    selectedSubCat.name = nameOfsubCategory
                })
            } catch {
                realmError(error)
            }
        }
    }
    
    func delete(_ subCategory: SubCategory) {
        if let selectedSubCat = selectedSubCat {
            let itemNumber = selectedSubCat.items.count
            if itemNumber == 0 {
                deleteWithAlert(subCategory)
            } else {
                errorAlert(with: "There is \(itemNumber) item(s) under this category. You can not delete it.")
            }
        } else {
            errorAlert(with: "Please select an item to delete.")
        }
    }
    
    func delete(subCate: SubCategory) {
        if let selectedSubCat = selectedSubCat {
            let itemNumber = selectedSubCat.items.count
            print("TTTTTTTTTT")
            if itemNumber == 0 {
                print ("EEEEEEEEE")
                guard let index =  selectedMainCat?.subCategories.firstIndex(of: selectedSubCat) else { print("SSSSSS"); return }
                do {
                    try myrealm?.write({
                        print("Here1")
                        selectedMainCat?.subCategories.remove(at: index)
                    })
                } catch {
                    
                }
            } else {
                errorAlert(with: "There is \(itemNumber) item(s) under this category. You can not delete it.")
            }
        } else {
            errorAlert(with: "Please select an item to delete.")
        }
    }
    
}
