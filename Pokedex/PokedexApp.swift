//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 25/9/22.
//

import SwiftUI

@main
struct PokedexApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
