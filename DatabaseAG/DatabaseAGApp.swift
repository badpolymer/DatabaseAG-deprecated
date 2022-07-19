//
//  DatabaseAGApp.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/21/22.
//

import SwiftUI

@main
struct DatabaseAGApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(MainController())
                .frame(minWidth: 1000, minHeight: 500,alignment: .topLeading)
        }
    }
}
