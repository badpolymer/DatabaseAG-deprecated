//
//  SubCatRow.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/22/22.
//

import SwiftUI

struct SubCatRow: View {
    var subCategory : SubCategory?
    var body: some View {
        if let name = subCategory?.name {
            VStack(spacing: 0.0) {
                HStack {
                    Text(name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    print(name)
                }
                Divider()
            }
        }
    }
}

struct SubCatRow_Previews: PreviewProvider {
    static var previews: some View {
        SubCatRow(subCategory: subcat_Bolt)
    }
}
