//
//  APIManager.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import UIKit



@MainActor
class APIManager: ObservableObject {
    
    @Published var searchResult: SearchResult? = nil
    
    @Published var searchText: String = ""
    
    @Published var fetchedArtworks: [Artwork] = []
    
//    private var thumbnailsCache: [Int: Thumbnail] = [:]
//    
//    private var objectsCache: [Int: Object] = [:]
    
    var searchKeywords: [String] = []
    
    var pages: [[Int]] = [[]]
    var pageToFetch: Int = 0
    
    @Published var isSaving = false
    
    func savePhoto(url urlString: String) {
        Task {
            self.isSaving = true
            
            do {
                guard let url = URL(string: urlString) else { throw APIError.badURL }
                
                let session = URLSession(configuration: .default)
                
                let (data, _) = try await session.data(from: url)
                
                let image = UIImage(data: data)
                
                if let unwrappedImage = image {
                    UIImageWriteToSavedPhotosAlbum(unwrappedImage, nil, nil, nil)
                }
            } catch {
                print(error)
            }
            
            self.isSaving = false
        }
    }
    
    func fetchMore() async {
        let lastPage = pages.count - 1
        
        var objectIDs: [Int] = []
        
        if pageToFetch + 1 <= lastPage {
            pageToFetch += 1
            objectIDs = pages[pageToFetch]
        }
        
        if !objectIDs.isEmpty {
            do {
                try await fetchArtworks(for: objectIDs)
            } catch {
                print(error)
            }
        }
    }
    
    private func setDefaults() {
        self.fetchedArtworks = []
        self.pages = [[]]
        self.pageToFetch = 0
    }
    
    func search() {
        Task(priority: .high) {
            try await fetchSearchResult()
        }
    }
    
    
    func fetchSearchResult() async throws {
        // Prepare for Search Request
        if searchText.isEmpty { throw APIError.emptySearchText }
        
        setDefaults()
        
        let text = self.searchText.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&q=\(text)"
        
        do {
            /// Creating URL and trying to fetch department list.
            guard let url = URL(string: urlString) else { throw APIError.badURL }
            
            let session = URLSession(configuration: .default)
            
            let (data, _) = try await session.data(from: url)
            
            /// Trying to decode JSON to Departments list
            let decoded = try JSONDecoder().decode(SearchResult.self, from: data)
            
            self.searchResult = decoded
            
            guard let ids = decoded.objectIDs else { throw APIError.objectsNil}
            
            self.pages = ids.chunked(into: 12)
            
            /// Load the first 20 thumbnails
            try await fetchArtworks(for: pages.first ?? [])
            
        } catch {
            print(error)
        }
    }
    
    func fetchArtworks(for ids: [Int]) async throws {
        do {
            /// Create empty dictionary for  [object id : image] pair
            var artworks: [Artwork] = []
            
            ///  Create async Task Group for concurrent downloading of thumbnails
            try await withThrowingTaskGroup(of: Artwork?.self) { group in
                for id in ids {
                    group.addTask { [self] in
                        return try await fetchOneArtwork(withID: id)
                    }
                }
                for try await artwork in group {
                    /// Add image of public object to Dictionary
                    if let unwrappedArtwork = artwork {
                        artworks.append(unwrappedArtwork)
                        
                        // Caching
//                        Task (priority: .background) {
//                            self.thumbnailsCache[id] = thumbnail
//                        }
                    }
                }
            }
            
            self.fetchedArtworks.append(contentsOf: artworks)
            
        } catch {
            print(error)
        }
    }
    
    func fetchOneArtwork(withID id: Int) async throws -> Artwork? {
        /// Preparing URL for fetching Object JSON Data
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)"
        guard let url = URL(string: urlString) else { throw APIError.badURL }
        let session = URLSession(configuration: .default)

        /// Trying to get Data from Object URL
        let (data, _) = try await session.data(from: url)
        
        /// Trying to decode Data to JSON
        let objectData = try JSONDecoder().decode(Object.self, from: data)
        
        // Caching
//        Task (priority: .background) {
//            self.objectsCache[id] = decoded
//        }
        
        if let imageUrl = objectData.primaryImageSmall, !imageUrl.isEmpty {
            /// Checked for availability of public image and creating URL
            guard let url = URL(string: imageUrl) else { throw APIError.badURL}
            
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else { throw APIError.badImage}
            
            let artwork = Artwork(id: id, image: image, objectData: objectData)
            
            return artwork
        } else {
            /// Object is not public and doesn't have a OA image
            return nil
        }
    }
    
    
    /// End of APIManager class
}
