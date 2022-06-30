//
//  SubCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI


struct SubCatList: View {
    @EnvironmentObject var controller : MainController
    var body: some View {
        VStack {
            List{
                if let subCategories = controller.selectedMainCat?.subCategories {
                    
                    
                    ForEach(subCategories) { subCategory in
                        SubCatRow(subCategory: subCategory)
                            .frame(height: 10)
                    }
                    
                }
            }.background()
            
            
            HStack(spacing: 5.0) {
                Spacer()
                Button("-") {
                    print("sdsds")
                }.frame(width: 25)
                Button("+") {
                    print("sdsds")
                }.frame(width: 25)
                Spacer()
                    .frame(width: 5)
            }
            
        }
    }
}

struct SubCatList_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SubCatList()
        
    }
}
