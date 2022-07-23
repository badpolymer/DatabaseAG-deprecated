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
            VStack {
                if let subCategories = controller.selectedMainCat?.subCategories {
                    if subCategories.count > 0 {
                        List(subCategories, id:\.self, selection:$selectedSubCat){ cat in
                            Text(cat.name)
                        }
                        
                        .onChange(of: selectedSubCat, perform: { newValue in
                            controller.selectedSubCat = controller.convert(newValue)
                        })
                        .disabled(controller.subCategoryIsEditing)
                    } else {
                        List(){
                        Text("No category yet.")
                        }
                    }
                }
                
                
                HStack(spacing: 5.0) {
                    Text(controller.selectedMainCat?.name ?? "Not selected")
                    Spacer()
                    Button("Edit") {
                        if selectedSubCat != nil && controller.selectedSubCat != nil {
                            controller.subCategoryIsEditing = true
                            editorName = controller.selectedSubCat!.name
                            notModifying = false
                        } else {
                            controller.categoryEditingError("You didn't select an item.")
                        }
                        
                    }.frame(width: 50)
                    Button("-") {
                        if let subCatToDelete = controller.selectedSubCat {
                        controller.delete(subCatToDelete)
                        } else {
                            controller.categoryEditingError("You didn't select an item.")
                        }
                    }.frame(width: 25)
                    Button("+") {
                        controller.subCategoryIsEditing = true
                        notModifying = true
                        controller.testfunc()
                    }.frame(width: 25)
                    Spacer()
                        .frame(width: 5)
                }
            }
            
            //right
            if controller.subCategoryIsEditing {
                VStack(alignment: .leading){
                    Text("Main: \(self.controller.selectedMainCat?.name ?? "Error")")
                    HStack {
                        Text("Name:")
                        TextField("Enter the name.", text: $editorName)
                    }
                    HStack{
                        Spacer()
                        Button {
                            controller.subCategoryIsEditing = false
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            if editorName.isEmpty {
                                controller.categoryEditingError("Please enter a name.")
                            } else {
                                if notModifying {
                                    controller.add(editorName)
                                } else {
                                    controller.modify(editorName)
                                }
                                controller.subCategoryIsEditing = false
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
