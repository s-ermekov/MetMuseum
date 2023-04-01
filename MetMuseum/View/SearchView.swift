//
//  Home.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        NavigationView {
            // Search Results
            VStack {
                if apiManager.isLoading, apiManager.fetchedArtworks.isEmpty {
                    // Show ProgressView while Loading Results
                    ProgressView {
                        Text("Loading results...")
                            .padding(.vertical)
                    }
                } else if let errorMessage = apiManager.errorMessage {
                    // Show Error Description if Catched
                    Text(errorMessage)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                } else if let artworks = apiManager.fetchedArtworks, !artworks.isEmpty {
                    // Show Search Results
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
                        .frame(width: Constants.width)
                        .padding(.vertical)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Searchable
            .searchable(text: $apiManager.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter search keywords") {
                // suggestions updating by typing search keyword from vocabulary
                ForEach(apiManager.searchKeywords.filter { $0.localizedCaseInsensitiveContains(apiManager.searchText) } , id: \.self) { keyword in
                    Text(keyword)
                        .searchCompletion(keyword)
                }
            }
            .autocorrectionDisabled()
            .onSubmit(of: .search) {
                apiManager.search()
                hideKeyboard()
            }
            
            // NavigationBar Properties
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Clear search results") { apiManager.clearResults() }
                        Button("Clear search keywords") { apiManager.clearKeywords() }
                    } label: {
                        Text("Clear")
                    }
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
