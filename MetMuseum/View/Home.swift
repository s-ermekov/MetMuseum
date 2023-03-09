//
//  Home.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var apiManager: APIManager
    
    // Search State properties
    @State private var searchText = ""
    
    // SearchResult
    let columns = [
        GridItem(.flexible(minimum: 150, maximum: 300), spacing: 2),
        GridItem(.flexible(minimum: 150, maximum: 300), spacing: 2)
    ]
    
    var body: some View {
        NavigationView {
            // Search Results
            ScrollView(.vertical) {
                ZStack {
                    if apiManager.fetchedThumbnails.isEmpty {
                        Image("metlogo")
                            .resizable()
                            .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
                            .scaledToFit()
                            .padding(50)
                    } else if let thumbnails = apiManager.fetchedThumbnails {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 2) {
                            ForEach(thumbnails, id: \.id) { thumbnail in
                                SearchResultCell(thumbnail: thumbnail)
                            }
                            
                            if !thumbnails.isEmpty {
                                ProgressView()
                                    .frame(minWidth: 150, maxWidth: 300, minHeight: 200, maxHeight: 250)
                                    .onAppear {
                                        Task {
                                            await apiManager.fetchPage()
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            
            // SearchField
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                apiManager.search(for: searchText)
            }
            
            // NavBar
            .navigationTitle("The Met Museum of Art")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "person.fill")
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
