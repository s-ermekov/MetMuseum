//
//  ContentView.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiManager: APIManager
    
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tag(0)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView().tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APIManager())
    }
}
