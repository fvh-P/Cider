//
//  CiderApp.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

@main
struct CiderApp: App {
    let sheetManager = PartialSheetManager()
    var body: some Scene {
        WindowGroup {
            TabView {
                LilyNavigationView()
                    .environmentObject(sheetManager)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .tabItem { Label("リリィ一覧", systemImage: "person.crop.rectangle.fill") }
                CharmListView(charms: [])
                    .environmentObject(sheetManager)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .tabItem { Label("CHARM一覧", systemImage: "wand.and.stars") }
            }
        }
    }
}

