//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 8/12/22.
//

import SwiftUI
import Dependiject

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerDependencies()
        return true
    }
    
    private func registerDependencies(){
        Factory.register {
            Service(.weak, HomeViewModel.self) { r in
                HomeViewModel(repository: r.resolve())
            }
            
            Service(.weak, DetailViewModel.self) { r in
                DetailViewModel(repository: r.resolve())
            }
            
            Service(.singleton, PokeApiRepository.self) { _ in
                PokeApiRepository(session: URLSession.shared)
            }
            
            Service(.singleton, PokemonTeamHelper.self) { _ in
                PokemonTeamHelper()
            }
        }
    }
}
