//
//  SearchResultView.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 11.03.2023.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var apiManager: APIManager
    
    let width = UIScreen.main.bounds.width - 48
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .center, spacing: 24) {
                if let artworks = apiManager.fetchedArtworks, !artworks.isEmpty {
                    ForEach(artworks, id: \.id) { artwork in
                        SearchResultCell(artwork: artwork)
                    }

                    ProgressView()
                        .frame(width: width, height: 50)
                        .task { await apiManager.fetchMore() }
                }
            }
            .padding(.top, 12)
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APIManager())
    }
}
