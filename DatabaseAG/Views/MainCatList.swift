//
//  MainCatList.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct MainCatList: View {
    @StateObject var controller = mainController
    var body: some View {
        List() {
            RootRow()
            ForEach(controller.rootItems){category in
                MainCatRow(category: category)
                    
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
