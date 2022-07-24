//
//  SubCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct SubCatList: View {
    @EnvironmentObject var controller : MainController
    @State private var selectedSubCategory : SubCategory?
    @State private var editorName: String = ""
    
    var body: some View {
        HStack(spacing: 5.0) {
            
// MARK: - Subcategories List and buttons
            if let subCategories = controller.subCategories {
                
                VStack {
                    
                    if subCategories.count > 0 {
                        List(subCategories, id:\.self, selection:$selectedSubCategory){ cat in
                            Text(cat.name)
                        }
                        
                        .onChange(of: selectedSubCategory, perform: { newValue in
                        })
                        .disabled(controller.mainCategoryManagerIsEditing)
                    } else {
                        List(){
                            Text("No category yet.")
                        }
                    }
                    
                    
                    
                    HStack(spacing: 5.0) {
                        Text(subCategories.first?.mainCategory.first?.name ?? "Not selected")
                        Spacer()
                        Button("Edit") {
                            
                            controller.mainCategoryManagerIsEditing = true
                            controller.operationIsComplete = false
                            editorName = selectedSubCategory!.name
                          
                            
                        }
                        .frame(width: 50)
                        .disabled(selectedSubCategory == nil)
                        Button("-") {
                            if let selectedSubCategory = selectedSubCategory {
                                controller.delete(selectedSubCategory)
                            }else {
                                controller.errorAlert(with: "You didn't select an items. Code: 020")
                            }
                            
                        }
                        .frame(width: 25)
                        .disabled(selectedSubCategory == nil)
                        Button("+") {
                            editorName = ""
                            controller.mainCategoryManagerIsEditing = true
                            controller.operationIsComplete = false
                            selectedSubCategory = nil
                            
                        }.frame(width: 25)
                        Spacer()
                            .frame(width: 5)
                    }
                }
            }
// MARK: - Main Category Manager
            if controller.mainCategoryManagerIsEditing {
                VStack(alignment: .leading){
                    Text("Main Category: \(self.controller.subCategories?.first?.mainCategory.first?.name ?? "Error")")
                    HStack {
                        Text("Name:")
                        TextField("Enter the name.", text: $editorName)
                            .disabled(controller.disableMainCategoryManagerEditing)
                    }
                    HStack{
                        Spacer()
                        Button {
                            controller.mainCategoryManagerIsEditing = false
                            editorName = ""
                        } label: {
                            Text("Cancel")
                        }
                        .disabled(controller.disableMainCategoryManagerEditing)
                        Button {
                            controller.updateOrAdd(selectedSubCategory, with: editorName)
                            editorName = ""
                            selectedSubCategory = nil
                        } label: {
                            Text("Save")
                        }
                        .disabled(controller.disableMainCategoryManagerEditing)
                        
                        
                        
                    }
                } //VStack
                .padding(5.0)
                .addBorder(Color.black,width: 1, cornerRadius: 10)
                
            } //End if controller.subCategoryIsEditing
            //End of right side
        }//End of HStack
    }//End of body
}


