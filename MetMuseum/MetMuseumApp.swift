//
//  MetMuseumApp.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

@main
struct MetMuseumApp: App {
    @StateObject var apiManager = APIManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiManager)
        }
    }
}
