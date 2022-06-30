//
//  RootRow.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct RootRow: View {
    @EnvironmentObject var mainController : MainController
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 5)
            HStack{
                Image(systemName: "point.filled.topleft.down.curvedto.point.bottomright.up")
                    
                    .frame(width: 20, height: 20)
                Text("Root Manager")
                Spacer()
            }.contentShape(Rectangle())
                .onTapGesture {
                    mainController.selectedMainCat = nil
                    mainController.rootManagerIsSelected = true
                    print("Root Manager")
                }
            Divider()
                .frame(height: 1, alignment: .leading)
            
        }
    }
}

struct RootRow_Previews: PreviewProvider {
    static var previews: some View {
        RootRow()
    }
}
