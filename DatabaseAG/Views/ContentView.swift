//
//  ContentView.swift
//  DatabaseAG
//
//  Created by Frederick Tang on 5/21/22.
//IMPORTANT//AVGear===================
//https://stackoverflow.com/questions/50459785/how-to-set-realm-file-on-realm
//==========================


import SwiftUI



struct ContentView: View {
    @EnvironmentObject var mainController : MainController
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            //Top Section
            Spacer()
                .frame(height: 10)
            HStack(alignment: .center) {
                Spacer()
                    .frame(width:5)
                Button("Load Database"){mainController.loadRealm()}
                Spacer()
                    .frame(width:5)
                Text(mainController.filePath ?? "Not Loaded")
                Spacer()
                Button {
                    mainController.selectedMainCat = nil
                    mainController.rootManagerIsSelected = true
                    print("Root Manager")
                } label: {
                    Image(systemName: "point.filled.topleft.down.curvedto.point.bottomright.up")
                    Text("Root Manager")
                }
                if mainController.rootManagerIsSelected {
                Button {
                    mainController.rootManagerIsSelected = false
                    print("Exit Root Manager")
                } label: {
                    Text("Exit RM")
                }
                }
                Spacer()
                    .frame(width:5)

            }.frame(width:1000)
            
            
            Spacer()
                .frame(height: 10)
            
            //Main Section
            HStack(spacing: 5.0) {
                Spacer()
                    .frame(width:0)
                
                //Root List
                if mainController.rootManagerIsSelected {
                    
                } else {
                VStack(spacing: 0.0) {
                    MainCatList()
                        .frame(width: 150)
                }
                }
                
                //Secondary List
                if !mainController.rootManagerIsSelected{
                    VStack {
                        SubCatList()
                            .frame(width: (mainController.mainCategoryManagerIsEditing ? 500:250))
                            
                    }
                }
                
                //Item List
                if !mainController.rootManagerIsSelected && !mainController.mainCategoryManagerIsEditing {
                    Text("Item List")
                }
                //Editers
                if mainController.rootManagerIsSelected {
                RootManager()
                }
                
            }
            
            
            //Bottom
            Spacer()
                .frame(height: 20)
        }
        
    }
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

//
//var main_Tool = MainCategory(name: "Tool", image: Image(systemName: "hammer.fill"), subCategories: nil)
//var main_Accessory = MainCategory(name: "Accessory", image: Image(systemName: "gearshape.2.fill"),subCategories: [subcat_Bolt,subcat_Nut])
//var main_Connector = MainCategory(name: "Connector", image: Image(systemName: "cable.connector.horizontal"), subCategories: [subcat_FRC])
//var main_Contact = MainCategory(name: "Contact", image: Image(systemName: "pencil"), subCategories: nil)
//var main_Terminal = MainCategory(name: "Terminal", image: Image(systemName: "memorychip"), subCategories: nil)
//var main_Wire = MainCategory(name: "Cable/Wire", image: Image(systemName: "scribble"), subCategories: nil)
//var main_Splice = MainCategory(name: "Splice", image: Image(systemName: "cylinder.fill"), subCategories: nil)
