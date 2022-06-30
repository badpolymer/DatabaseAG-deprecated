//
//  CategoryEditer.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 19/6/2022.
//

import SwiftUI
import RealmSwift

struct RootManager: View {
    @EnvironmentObject var mainController : MainController
    @State private var selectedMainCat : MainCategory?
    
    @State private var mainCatName : String = ""
    @State private var mainCatSymbol : String = ""
    
    @State private var disableMainCatEditing : Bool = true
   
    
    var body: some View {
        HStack {
            
// MARK: - Left Side
            VStack(alignment: .leading) {
                
                List() {
                    if mainController.mainCategories != nil {
                        ForEach(mainController.mainCategories!){category in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text(category.name)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.selectedMainCat = category
                                    self.mainCatName = category.name
                                    self.mainCatSymbol = category.image
                                    mainController.dataChangeIsComplete = false
                                    print(self.selectedMainCat!)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                
                            }
                            
                        }
                    } else {
                        Text("Nothing here yet.")
                        
                    }
                    
                }
                .frame(width:250, height:400)
                .listStyle(.plain)
                
                HStack {
                    
                    Button {
                        //Action for deselect
                        selectedMainCat = nil
                        mainCatName = ""
                        mainCatSymbol = ""
                    } label: {
                        Text("Deselect all")
                    }
                    Button {
                        //Action for -
                        if selectedMainCat != nil {
                            mainController.deleteMainCat(selectedMainCat!)
                            selectedMainCat = nil
                            mainCatName = ""
                            mainCatSymbol = ""
                        } else {
                            mainController.mainCatEditingError("You didn't select an items.")
                        }
                        
                    } label: {
                        Text("-")
                    }
                    Button {
                        //Action for +
                        selectedMainCat = nil
                        mainCatName = ""
                        mainCatSymbol = "questionmark.square.dashed"
                        disableMainCatEditing = false
                        mainController.dataChangeIsComplete = false
                    } label: {
                        Text("+")
                    }
                    Button {
                        //Action for Edit
                        if selectedMainCat != nil {
                            disableMainCatEditing = false
                            mainController.dataChangeIsComplete = false
                            
                        } else {
                            mainController.mainCatEditingError("You didn't select an items.")
                        }
                    } label: {
                        Text("Edit")
                    }
                }
            }
            
            
// MARK: - Right side
            VStack(alignment: .leading) {
                
              
                
                Text(selectedMainCat == nil ? "New Main Category" : selectedMainCat!.name)
                    .padding([.top, .leading], 5.0)
                
                TextField("Enter the name of Main Category", text: $mainCatName)
                    .frame(width: 246, alignment: .topLeading)
                    .disabled(disableMainCatEditing)
                    .padding(.horizontal, 2.0)
                    .cornerRadius(10)
                
                TextField("Enter the SF symbol name", text: $mainCatSymbol)
                    .frame(width: 246, alignment: .topLeading)
                    .disabled(disableMainCatEditing)
                    .padding(.horizontal, 2.0)
                    .cornerRadius(10)
                
                HStack {
                    Text("Icon:")
                    if mainCatSymbol.count != 0{
                        Image(systemName: mainCatSymbol)
                    }
                    Spacer()
                    Button {
                        //Action
                        disableMainCatEditing = true
                        if mainController.realmIsLoaded() {
                            if selectedMainCat == nil {
                                mainController.addMainCat(name: mainCatName, symbol: mainCatSymbol)
                                if mainController.dataChangeIsComplete {
                                    
                                } else {
                                    disableMainCatEditing = false
                                }
                            } else {
                                mainController.updateMainCat(selectedMainCat!,name: mainCatName,symbol: mainCatSymbol)
                            }
                        } else {
                            disableMainCatEditing = false
                            mainController.realmError(NSError(domain: "DB Not Loaded", code: 2))
                        }
                        
                    } label: {
                        Text(mainController.dataChangeIsComplete ? "Suscceed":"Save")
                    }
                    .disabled(disableMainCatEditing)
                    
                }.padding([.leading, .bottom, .trailing], 5.0)
                
                
            }  //VStack
            .frame(width:250)
            .addBorder(disableMainCatEditing ? Color.black: Color.blue , width: 1, cornerRadius: 10)
            
            
            
        }
    }
}






extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}




struct CategoryEditer_Previews: PreviewProvider {
    static var previews: some View {
        RootManager()
            .preferredColorScheme(.light)
            .environmentObject(MainController())
            
        
    }
}
