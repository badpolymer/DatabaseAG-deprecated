//
//  MainCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct MainCatList: View {
    @EnvironmentObject var mainController : MainController
    var body: some View {
        List() {
            RootRow()
            if let categories = mainController.mainCategories {
                ForEach(categories){category in
                    MainCatRow(category: category)
                        
                }
            }

        }
        .listStyle(.plain)
    }
}

struct MainCatList_Previews: PreviewProvider {
    static var previews: some View {
        MainCatList()
    }
}
