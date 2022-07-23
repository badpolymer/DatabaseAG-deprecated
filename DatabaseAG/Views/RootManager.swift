//
//  CategoryEditer.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 19/6/2022.
//

import SwiftUI

struct RootManager: View {
    @EnvironmentObject var mainController : MainController
    @State private var selectedMainCat : MainCategory?
    @State private var title : String = "New Main Category"
    @State private var mainCatName : String = ""
    @State private var mainCatSymbol : String = ""
    @State private var disableMainCatEditing : Bool = true
   
    
    var body: some View {
        HStack {
            
// MARK: - Left Side
            VStack(alignment: .leading) {
                if let mainCategories = mainController.mainCategories {
                    List(mainCategories, id:\.self, selection: $selectedMainCat) { category in
                        HStack{
                            Image(systemName: category.image)
                                .frame(width: 20, height: 20)
                            Text(category.name)
                        }
                        
                    }
                    .frame(width:250)
                    .onChange(of: selectedMainCat) { newValue in
                        if let mainCategory = newValue {
                            title = mainCategory.name
                            mainCatName = mainCategory.name
                            mainCatSymbol = mainCategory.image
                        } else {
                            title = "New Main Category"
                            mainCatName =  ""
                            mainCatSymbol =  ""
                        }
                        mainController.operationIsComplete = false
                    }
                    .disabled(!disableMainCatEditing)
                    
                } else {
                    List(){
                        Text("Nothing here yet.")
                    }
                    .frame(width:250)
                    .disabled(!disableMainCatEditing)
                }
                
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
                        mainController.operationIsComplete = false
                        if let categoryToDelete = selectedMainCat {
                            mainController.delete(categoryToDelete)
                            selectedMainCat = nil
                            mainCatName = ""
                            mainCatSymbol = ""
                            title = "New Main Category"
                        } else {
                            mainController.errorAlert(with: "You didn't select an items.")
                        }
                        
                    } label: {
                        Text("-")
                    }
                    .disabled(selectedMainCat == nil)
                    Button {
                        //Action for +
                        selectedMainCat = nil
                        title = "New Main Category"
                        mainCatName = ""
                        mainCatSymbol = ""
                        disableMainCatEditing = false
                        mainController.operationIsComplete = false
                    } label: {
                        Text("+")
                    }
                    Button {
                        //Action for Edit
                        disableMainCatEditing = false
                        mainController.operationIsComplete = false

                    } label: {
                        Text("Edit")
                    }
                    .disabled(selectedMainCat == nil)
                }
            }
            
            
// MARK: - Right side
            VStack(alignment: .leading) {
                
                Text(title)
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
                        disableMainCatEditing = true
                    } label: {
                        Text("Cancel")
                    }
                    .disabled(disableMainCatEditing)

                    Button {
                        //Action for Save
                        disableMainCatEditing = true
                        mainController.updateOrAddMainCat(selectedMainCat, newName: mainCatName, newSymbol: mainCatSymbol)
                        if mainController.operationIsComplete {
                            
                        } else {
                            disableMainCatEditing = false
                        }
                        
                        
                    } label: {
                        Text(mainController.operationIsComplete ? "Suscceed":"Save")
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
