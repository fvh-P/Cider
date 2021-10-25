//
//  CiderApp.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

@main
struct CiderApp: App {
    private let sheetManager = PartialSheetManager()
    private let lilyNavigationHelper = LilyNavigationHelper()
    private let charmNavigationHelper = CharmNavigationHelper()
    @State private var tabSelection = 1
    @State private var tappedTwice: Bool = false
    
    var handler: Binding<Int> { Binding(
        get: { self.tabSelection },
        set: {
            if $0 == self.tabSelection {
                self.tappedTwice = true
            }
            self.tabSelection = $0
        }
    )}
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: handler) {
                LilyNavigationView()
                    .environmentObject(sheetManager)
                    .environmentObject(lilyNavigationHelper)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .onChange(of: self.tappedTwice) { tapped in
                        if tapped && self.tabSelection == 1 {
                            self.lilyNavigationHelper.selection = nil
                            self.tappedTwice = false
                        }
                    }
                    .tabItem { Label("リリィ一覧", systemImage: "person.crop.rectangle.fill") }
                    .tag(1)
                CharmNavigationView()
                    .environmentObject(sheetManager)
                    .environmentObject(charmNavigationHelper)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .onChange(of: self.tappedTwice) { tapped in
                        if tapped && self.tabSelection == 2 {
                            self.charmNavigationHelper.selection = nil
                            self.tappedTwice = false
                        }
                    }
                    .tabItem { Label("CHARM一覧", image: "custom.weapon.fill") }
                    .tag(2)
            }
        }
    }
}

