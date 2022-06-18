//
//  ContentView.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/21/22.
//

import SwiftUI


var mainController = MainController()

struct ContentView: View {
    @StateObject var controller = mainController
    
    var body: some View {
        
            HStack(spacing: 10.0) {
                VStack(spacing: 0.0) {
                    Spacer()
                        .frame(height: 20)
                    MainCatList()
                        .frame(width: 150)
                    Spacer()
                        .frame(height: 20)
                }
                if controller.rootManagerIsSelected {
                    
                } else {
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        SubCatList()
                            .frame(width: 200)
                        
                        
                        Spacer()
                            .frame(height: 20)
                    }
                }
                
            }
            
        }
    
    }






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


var main_Tool = MainCategory(name: "Tool", image: Image(systemName: "hammer.fill"), subCategories: nil)
var main_Accessory = MainCategory(name: "Accessory", image: Image(systemName: "gearshape.2.fill"),subCategories: [subcat_Bolt,subcat_Nut])
var main_Connector = MainCategory(name: "Connector", image: Image(systemName: "cable.connector.horizontal"), subCategories: [subcat_FRC])
var main_Contact = MainCategory(name: "Contact", image: Image(systemName: "pencil"), subCategories: nil)
var main_Terminal = MainCategory(name: "Terminal", image: Image(systemName: "memorychip"), subCategories: nil)
var main_Wire = MainCategory(name: "Cable/Wire", image: Image(systemName: "scribble"), subCategories: nil)
var main_Splice = MainCategory(name: "Splice", image: Image(systemName: "cylinder.fill"), subCategories: nil)
