//
//  MainController.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import AppKit
import RealmSwift

class MainController : ObservableObject {
    private var myrealm: Realm?
    @Published var filePath : String?
    @Published var mainCategories : [MainCategory]?
    @Published var rootManagerIsSelected : Bool = true {
        didSet {
            if rootManagerIsSelected {
                startObservingMainCategoriesChange()
                self.selectedMainCategory = nil
                self.selectedMainItem = nil
            } else {
//                stopObservingMainCategoriesChange()
            }
        }
    }
    //Change Listeners
    private var mainCategoriesChangeListener: NotificationToken?
    
    //SubCatlist
    var selectedMainCategory: MainCategory? {
        didSet{
            reloadSubCategories(under: selectedMainCategory)
        }
    }
    @Published var subCategories : [SubCategory]?
    @Published var mainCategoryManagerIsEditing = false
    @Published var disableMainCategoryManagerEditing = false

    //Item List
    @Published var selectedSubcategory: SubCategory?{
        didSet{
            reloadItems(under: selectedSubcategory)
        }
    }
    @Published var items: [MainItem]?
    
    
    
    
    @Published var selectedMainItem : MainItem?
    
    @Published var operationIsComplete : Bool = false
    
    
    
   
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
                    print(" Delete at index: ",deletions,"\n","Insert at index: ", insertions, "\n","modify at index: ", modifications)
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
//                    self.startObservingMainCategoriesChange()
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
    
    // MARK: - Realm CRUD Method Base Error Code: 000
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
            errorAlert(with: "Database is not loaded. Code: 001")
        }
    }
    
    private func add<T:Object, M: Object>(_ object: M, to superObject: List<T>) {
        self.operationIsComplete = false
        if let database = myrealm {
            do {
                try database.write({
                    superObject.append(object as! T)
                    self.operationIsComplete = true
                })
            } catch {
                realmError(error)
            }
        } else {
            errorAlert(with: "Database is not loaded. Code: 003")
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
            errorAlert(with: "Database is not loaded. Code: 002")
        }
    }
    
    func delete(_ object: Object) {
        switch object {
        case is MainCategory:
            let mainCategory = object as! MainCategory
            let subCategoryNumber = mainCategory.subCategories.count
            if subCategoryNumber > 0 {
                errorAlert(with: "There is one or more subcategory in this Category. You cannot remove it. Code: 004")
            } else {
                deleteWithAlert(mainCategory)
                reloadMainCategories()
            }
            
        case is SubCategory:
            let subCategory = object as! SubCategory
            let itemNumber = subCategory.items.count
            if itemNumber > 0 {
                errorAlert(with: "There is one or more item in this Category. You cannot remove it. Code: 005")
            } else {
                deleteWithAlert(subCategory)
                reloadSubCategories(under: selectedMainCategory)
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
            print("You Clicked CANCEL")
        case NSApplication.ModalResponse.alertSecondButtonReturn:
            deleteFromDatabase(itemToDelete)
        default:
            print("There is no provision for further buttons")
        }
    }
    
    // MARK: - Root Manager (Main Categories) Base Error Code: 090
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
                        errorAlert(with: "\(trimedName) already exists. Code: 091")
                    } else if countDuplicationInMainCategories(by: trimedName) == 1 {
                        let duplicate = database.objects(MainCategory.self).where({$0.name == trimedName}).first?.id
                        if editingCategory.id != duplicate {
                            errorAlert(with: "\(trimedName) already exists. Code: 092")
                        } else {
                            //Not duplicated
                            update(editingCategory, trimedName, trimedSymbol)
                        }
                    } else {
                        //Not duplicated
                        update(editingCategory, trimedName, trimedSymbol)
                    }
                } else {
                    // Add New Category
                    if countDuplicationInMainCategories(by: trimedName) > 0 {
                        errorAlert(with: "\(trimedName) already exists. Code: 093")
                    } else {
                        let newCategory = MainCategory(name: trimedName, image: trimedSymbol)
                        add(newCategory)
                        reloadMainCategories()
                    }
                }
            } else {
                errorAlert(with: "The name of category cannot be empty. Code: 095")
            }
        } else {
            errorAlert(with: "Database is not loaded. Code: 096")
        }
    }
    
    private func countDuplicationInMainCategories(by name: String) -> Int {
        if let existingCategories = myrealm?.objects(MainCategory.self).where({$0.name == name}) {
            return existingCategories.count
        } else {
            return 0
        }
    }
    
    private func update(_ m: MainCategory, _ n: String, _ s: String ) {
        do {
            try myrealm?.write{
                m.name = n
                m.image = s
            }
            operationIsComplete = true
            reloadMainCategories()
        } catch {
            realmError(error)
        }
    }
    
    // MARK: - Subcategory List(Main Category Manager) Base Error Code: 100
    func reloadSubCategories(under mainCategory: MainCategory?) {
        if let category = mainCategory, let datebase = myrealm {
            let subcategories = Array(datebase.objects(SubCategory.self).where{$0.mainCategory == category})
            self.subCategories = subcategories
        } else {
            subCategories = nil
        }
    }
    
    func updateOrAdd(_ subcategory: SubCategory?, with name: String) {
        self.operationIsComplete = false
        self.disableMainCategoryManagerEditing = true
        let trimedName = name.trimmingCharacters(in: .whitespaces)
        if trimedName.isEmpty {
            mainCategoryManagerAlert(with: "The name of category cannot be empty. Code: 100")
            return
        }
        if let selectedMainCategory = self.selectedMainCategory {
            
            if let editingSubcategory = subcategory {
                //Edit an existing Subgategory
                let duplication = countDuplicationInSubcategories(by: name, under: selectedMainCategory)
                switch duplication {
                case 0:
                    update(editingSubcategory, with: trimedName)
                    closeMainCategoryManager()
                case 1:
                    if let database = myrealm{
                        let suspectedCategory = database.objects(SubCategory.self).where{$0.name == trimedName && $0.mainCategory == selectedMainCategory}
                        if editingSubcategory.id == suspectedCategory.first?.id {
                            //not duplicated
                            update(editingSubcategory, with: trimedName)
                            closeMainCategoryManager()
                        } else {
                            mainCategoryManagerAlert(with: "\(name) already exists. Code: 102")
                        }
                    } else {
                        mainCategoryManagerAlert(with: "Database is not loaded. Code: 103")
                    }
                default:
                    mainCategoryManagerAlert(with: "\(name) already exists. Code: 101")
                }
                
                
            } else {
                // Add a new Subcategory
                let duplication = countDuplicationInSubcategories(by: name, under: selectedMainCategory)
                if duplication == 0 {
                    let newCategory = SubCategory()
                    newCategory.name = name
                    self.add(newCategory, to: selectedMainCategory.subCategories)
                    closeMainCategoryManager()
                } else {
                    mainCategoryManagerAlert(with: "\(name) already exists. Code: 100")
                }
            }
        } else {
            mainCategoryManagerAlert(with: "You didn't select any category. Code: 104")
            return
        }
    }
    
    private func mainCategoryManagerAlert(with alert: String) {
        errorAlert(with: alert)
        self.disableMainCategoryManagerEditing = false
    }
    
    private func update(_ subcategory : SubCategory, with newName: String) {
        do {
            try myrealm?.write{
                subcategory.name = newName
            }
            operationIsComplete = true
            
        } catch {
            realmError(error)
        }
    }
    
    private func countDuplicationInSubcategories(by name: String, under mainCategory: MainCategory) -> Int {
        if let existingCategories = myrealm?.objects(SubCategory.self).where({$0.name == name && $0.mainCategory == mainCategory }) {
            return existingCategories.count
        } else {
            return 0
        }
    }
    
    private func closeMainCategoryManager() {
        self.reloadSubCategories(under: self.selectedMainCategory)
        self.mainCategoryManagerIsEditing = false
        self.disableMainCategoryManagerEditing = false
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
    
}
