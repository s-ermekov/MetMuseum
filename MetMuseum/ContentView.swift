//
//  ContentView.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APIManager())
    }
}
