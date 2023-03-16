//
//  Home.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var apiManager: APIManager
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            // Search Results
            VStack {
                if apiManager.isLoading, apiManager.fetchedArtworks.isEmpty {
                    ProgressView {
                        Text("Loading results...")
                            .padding(.vertical)
                    }
                } else if let errorMessage = apiManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                } else if let artworks = apiManager.fetchedArtworks, !artworks.isEmpty {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .center, spacing: 24) {
                            ForEach(artworks, id: \.id) { artwork in
                                SearchViewCell(artwork: artwork)
                            }
                            
                            if apiManager.canFetchMore {
                                Button { apiManager.fetchMore() } label: {
                                    Text("Show more")
                                        .overlay {
                                            if apiManager.isLoading {
                                                ProgressView()
                                            }
                                        }
                                }
                                .disabled(apiManager.isLoading)
                                .buttonStyle(.bordered)
                            }
                        }
                        .frame(width: width)
                        .padding(.vertical)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // SearchField
            .searchable(text: $apiManager.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter search keywords") {
                // suggestions updating by typing search keyword from vocabulary
                ForEach(apiManager.searchKeywords.filter { $0.localizedCaseInsensitiveContains(apiManager.searchText) } , id: \.self) { keyword in
                    Text(keyword)
                        .searchCompletion(keyword)
                }
            }
            .autocorrectionDisabled()
            .onSubmit(of: .search) { apiManager.search() }
            
            // NavBar
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") { apiManager.allClear() }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APIManager())
    }
}
