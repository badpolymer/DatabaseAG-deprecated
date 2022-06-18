//
//  ItemRow.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct ItemRow: View {
    @StateObject var controller = mainController
    var itemFamalyPN : String
    var body: some View {
        Text(itemFamalyPN)
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(itemFamalyPN: "BACC45FL()")
    }
}
