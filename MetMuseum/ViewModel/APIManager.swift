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
    
    @Published var errorMessage: String? = nil
    
    @Published var isLoading: Bool = false
    
    
    // MARK: - Previous search keywords
    var searchKeywords: [String] = [] {
        didSet {
            print(searchKeywords)
            saveKeywords()
        }
    }
    
    init() {
        do {
            let data = try Data(contentsOf: FileManager.keywordsPath)
            searchKeywords = try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            searchKeywords = []
        }
    }
    
    func saveKeywords() {
        do {
            let data = try JSONEncoder().encode(searchKeywords)
            try data.write(to: FileManager.keywordsPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func addKeyword(_ keyword: String) {
        if searchKeywords.contains(keyword) {
            if let indexOfKeyword = searchKeywords.firstIndex(of: keyword) {
                searchKeywords.remove(at: indexOfKeyword)
                searchKeywords.insert(keyword, at: 0)
            }
        } else {
            searchKeywords.insert(keyword, at: 0)
        }
    }
    
    // MARK: - Pagination
    var canFetchMore: Bool { return pageToFetch < pages.count - 1 }
    private var pages: [[Int]] = [[]]
    private var pageToFetch: Int = 0
    
    func fetchMore() {
        var objectIDs: [Int] = []
        if pageToFetch + 1 <= pages.count - 1 {
            pageToFetch += 1
            objectIDs = pages[pageToFetch]
        }
        if !objectIDs.isEmpty {
            Task {
                do {
                    try await fetchArtworks(for: objectIDs)
                } catch let error as APIError {
                    print("DEBUG: \(error.description)")
                }
            }
        }
    }
    
    // MARK: - Set to Defaults
    func allClear() {
        self.fetchedArtworks = []
        self.pages = [[]]
        self.pageToFetch = 0
        self.errorMessage = nil
    }
    
    // MARK: - Search Activate
    func search() {
        Task(priority: .high) {
            try await fetchSearchResult()
        }
    }
    
    // MARK: - Fetching Search Result
    func fetchSearchResult() async throws {
        // Prepare for Search Request
        if searchText.isEmpty { throw APIError.emptySearchText }
        
        addKeyword(searchText)
        
        allClear()
        
        let text = self.searchText.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&q=\(text)"
        
        do {
            /// Creating URL and trying to fetch department list.
            guard let url = URL(string: urlString) else { throw APIError.badURL }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            /// Trying to decode JSON to Departments list
            let decoded = try JSONDecoder().decode(SearchResult.self, from: data)
            
            self.searchResult = decoded
            
            print("DEBUG: Total amount of objects: \(decoded.total).")
            
            guard let ids = decoded.objectIDs else { throw APIError.objectsNil}
            
            self.pages = ids.chunked(into: 10)
            
            /// Load the first 10 thumbnails
            try await fetchArtworks(for: pages.first ?? [])
            
        } catch let error as APIError {
            self.errorMessage = error.description
            
            print("DEBUG: \(error.description)")
        }
    }
    
    // MARK: - Fetching Images If Available Asynchronously withThrowingTaskGroup
    func fetchArtworks(for ids: [Int]) async throws {
        isLoading = true
        
        do {
            /// Create empty dictionary for  [object id : image] pair
            var artworks: [Artwork] = []
            
            ///  Create async Task Group for concurrent downloading of thumbnails
            try await withThrowingTaskGroup(of: Artwork?.self) { group in
                for id in ids {
                    if !fetchedArtworks.contains(where: { $0.id == id }) {
                        group.addTask { [self] in
                            return try await fetchOneArtwork(withID: id)
                        }
                    }
                }
                for try await artwork in group {
                    /// Add image of public object to Dictionary
                    if let unwrappedArtwork = artwork {
                        artworks.append(unwrappedArtwork)
                    }
                }
            }
            
            self.fetchedArtworks.append(contentsOf: artworks)
            
        } catch let error as APIError {
            self.errorMessage = error.description
            
            print("DEBUG: \(error.description)")
        }
        
        print("DEBUG: \(fetchedArtworks.count) objects with public images were loaded totally.")
        
        if fetchedArtworks.isEmpty {
            self.errorMessage = APIError.noPublicImages.description
        }
        
        isLoading = false
    }
    
    // MARK: - Fetching Thumbnail Image
    func fetchOneArtwork(withID id: Int) async throws -> Artwork? {
        /// Preparing URL for fetching Object JSON Data
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)"
        
        guard let url = URL(string: urlString) else { throw APIError.badURL }
        
        /// Trying to get Data from Object URL
        let (data, _) = try await URLSession.shared.data(from: url)
        
        /// Trying to decode Data to JSON
        let objectData = try JSONDecoder().decode(Object.self, from: data)
        
        if let imageUrl = objectData.primaryImageSmall, !imageUrl.isEmpty {
            /// Checked for availability of public image and creating URL
            guard let url = URL(string: imageUrl) else { throw APIError.badURL}
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { throw APIError.badImage}
            
            print("DEBUG: Image is loaded #\(id).")
            
            let artwork = Artwork(id: id, image: image, objectData: objectData)
            
            return artwork
        } else {
            /// Object is not public and doesn't have a OA image
            return nil
        }
    }
}
