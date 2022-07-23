//
//  MainCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct MainCatList: View {
    @EnvironmentObject var mainController : MainController
    @State private var selected : UUID?
    var body: some View {
        VStack{
            if let categories = mainController.mainCategories {
                List(categories, selection: $selected) {cat in
                    
                    HStack{
                        Image(systemName: cat.image)
                        .frame(width: 20, height: 20)
                        
                        Text(cat.name)
                        Spacer()
                    }
  
                }
                .listStyle(.plain)
                .onChange(of: selected) { newValue in
                    mainController.reloadSubCategories(under: newValue)
                }
                .disabled(mainController.subCategoryIsEditing)
            }
        }
    }
}

struct MainCatList_Previews: PreviewProvider {
    static var previews: some View {
        MainCatList()
    }
}
