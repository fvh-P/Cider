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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionFooterHeight = 0
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        return true
    }
}

