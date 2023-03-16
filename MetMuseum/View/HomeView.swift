//
//  MainView.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 16.03.2023.
//

import SwiftUI

struct HomeView: View {
    let application: String = "application"
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 2)
                    .clipped()
                    .opacity(0.05)
                    .ignoresSafeArea()
                
                Text("A simple application for searching and downloading images of \(Attribute("Open Access").semibold) artworks from \(Attribute("https://metmuseum.org").link)")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .navigationTitle("The Met Museum")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
