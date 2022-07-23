//
//  SubCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI
import RealmSwift

struct SubCatList: View {
    @EnvironmentObject var controller : MainController
    @State private var selectedSubCat : SubCategory?
    @State private var editorName: String = ""
    @State private var notModifying: Bool = true
    
    var body: some View {
        HStack(spacing: 5.0) {
            
            //Left
            if let subCategories = controller.subCategories {
                
                VStack {
                    
                    if subCategories.count > 0 {
                        List(subCategories, id:\.self, selection:$selectedSubCat){ cat in
                            Text(cat.name)
                        }
                        
                        .onChange(of: selectedSubCat, perform: { newValue in
                        })
                        .disabled(controller.mainCategoryManagerIsEditing)
                    } else {
                        List(){
                            Text("No category yet.")
                        }
                    }
                    
                    
                    
                    HStack(spacing: 5.0) {
                        Text(controller.selectedMainCat?.name ?? "Not selected")
                        Spacer()
                        Button("Edit") {
                            if selectedSubCat != nil && controller.selectedSubCat != nil {
                                controller.mainCategoryManagerIsEditing = true
                                editorName = controller.selectedSubCat!.name
                                notModifying = false
                            } else {
                                controller.errorAlert(with: "You didn't select an item.")
                            }
                            
                        }.frame(width: 50)
                        Button("-") {
                            if let subCatToDelete = controller.selectedSubCat {
                                controller.delete(subCatToDelete)
                            } else {
                                controller.errorAlert(with: "You didn't select an item.")
                            }
                            print(controller.selectedMainCat?.subCategories ?? "1234567890")
                        }.frame(width: 25)
                        Button("+") {
                            controller.mainCategoryManagerIsEditing = true
                            notModifying = true
                            controller.reloadSubCat()
                        }.frame(width: 25)
                        Spacer()
                            .frame(width: 5)
                    }
                }
            }
            //right
            if controller.mainCategoryManagerIsEditing {
                VStack(alignment: .leading){
                    Text("Main: \(self.controller.selectedMainCat?.name ?? "Error")")
                    HStack {
                        Text("Name:")
                        TextField("Enter the name.", text: $editorName)
                    }
                    HStack{
                        Spacer()
                        Button {
                            controller.mainCategoryManagerIsEditing = false
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            if editorName.isEmpty {
                                controller.errorAlert(with: "Please enter a name.")
                            } else {
                                if notModifying {
                                    controller.add(editorName)
                                } else {
                                    controller.modify(editorName)
                                }
                                controller.mainCategoryManagerIsEditing = false
                                editorName = ""
                            }
                        } label: {
                            Text("Save")
                        }
                        
                        
                        
                    }
                } //VStack
                .padding(5.0)
                .addBorder(Color.black,width: 1, cornerRadius: 10)
                
            } //End if controller.subCategoryIsEditing
            //End of right side
        }//End of HStack
    }//End of body
}

struct SubCatList_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SubCatList()
            .environmentObject(MainController())
            .preferredColorScheme(.light)
        
    }
}
