//
//  MainCatRow.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct MainCatRow: View {
    var category : MainCategory
    var body: some View {
        VStack {
            HStack{
                category.image
                    .frame(width: 20, height: 20)
                
                Text(category.name)
                Spacer()
            }.contentShape(Rectangle())
            .onTapGesture {
                mainController.rootManagerIsSelected = false
                mainController.selectedMainCat = category
                print(mainController.selectedMainCat?.name ?? "No Selection")
            }
            Divider()
                .frame(height: 1)
            
        }
        
        
    }
}

//struct MainCatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCatRow(category: mainController.mainCategories.first!)
//    }
//}
