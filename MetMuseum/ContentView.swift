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
            SearchView().tag(0)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            InfoView().tag(1)
                .tabItem {
                    Label("Information", systemImage: "info.circle")
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
