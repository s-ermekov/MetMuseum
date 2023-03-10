//
//  Home.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var apiManager: APIManager
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    
    let width = UIScreen.main.bounds.width - 48
    
    var body: some View {
        NavigationView {
            // Search Results
            SearchResultView()
            
            // SearchField
            .searchable(text: $apiManager.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search") {
                ForEach(apiManager.searchKeywords, id: \.self) { keyword in
                    Text(keyword).searchCompletion(keyword)
                        .foregroundColor(.blue)
                }
                
                // suggestions updating by typing search keyword from vocabulary
//                ForEach(apiManager.keywords.filter { $0.localizedCaseInsensitiveContains(searchText) } , id: \.self) { suggestion in
//                    Text(suggestion)
//                        .searchCompletion(suggestion)
//                }
            }
            .onSubmit(of: .search) { apiManager.search() }
            
            // NavBar
            .navigationTitle("The Met Museum of Art")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
