//
//  APIManager.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 05.03.2023.
//

import UIKit



@MainActor
class APIManager: ObservableObject {
    
    @Published var searchKeyword: String = ""
    
    @Published var fetchedThumbnails: [Thumbnail] = []
    
    @Published var searchResult: SearchResult? = nil
    
    var pages: [[Int]] = [[]]
    var currentPage: Int = 0
    
    func fetchPage() async {
        if !pages.isEmpty, currentPage + 1 <= pages.count - 1 {
            
            let page = pages[currentPage]
            
            print(currentPage)
            print(page)
            
            await loadThumbnails(for: page)
            
            self.currentPage += 1
        }
    }
    
    func search(for searchText: String) {
        if !searchText.isEmpty {
            DispatchQueue.main.async {
                self.fetchedThumbnails = []
                self.pages = [[]]
                self.currentPage = 0
            }
            
            Task {
                try await fetchSearchResult(for: searchText)
            }
        }
    }
    
    
    func fetchSearchResult(for searchText: String) async throws {
        let text = searchText.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&q=\(text)"
        
        do {
            /// Creating URL and trying to fetch department list.
            guard let url = URL(string: urlString) else { throw APIError.badURL }
            
            let session = URLSession(configuration: .default)
            
            let (data, _) = try await session.data(from: url)
            
            /// Trying to decode JSON to Departments list
            let decoded = try JSONDecoder().decode(SearchResult.self, from: data)
            
            DispatchQueue.main.async {
                self.searchResult = decoded
            }
            
            guard let ids = decoded.objectIDs else { throw APIError.objectsNil}
            
            self.pages = ids.chunked(into: 20)
            
            /// Load thumbnails asynchronously
            await fetchPage()
//            await loadThumbnails(for: ids)
            
        } catch {
            print(error)
        }
    }
    
    func loadThumbnails(for ids: [Int]) async {
        do {
            /// Async thumbnails fetching
            let thumbnails = try await self.fetchThumbnails(for: ids)
            
            /// Update thumbnails
            DispatchQueue.main.async {
                self.fetchedThumbnails.append(contentsOf: thumbnails)
            }
        } catch {
            print(error)
        }
        
    }
    
    func fetchThumbnails(for ids: [Int]) async throws -> [Thumbnail] {
        /// Create empty dictionary for  [object id : image] pair
        var thumbnails: [Thumbnail] = []
        
        ///  Create async Task Group for concurrent downloading of thumbnails
        try await withThrowingTaskGroup(of: (Int, UIImage?).self) { group in
            for id in ids {
                group.addTask { [self] in
                    return (id, try await fetchOneThumbnail(withID: id))
                }
            }
            for try await (id, thumbnail) in group {
                /// Add image of public object to Dictionary
                if let image = thumbnail {
                    let thumbnail = Thumbnail(id: id, image: image)
                    thumbnails.append(thumbnail)
                }
            }
        }
        
        /// Return Dictionary of Public Object with Available images
        return thumbnails
    }
    
    func fetchOneThumbnail(withID id: Int) async throws -> UIImage? {
        /// Preparing URL for fetching Object JSON Data
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)"
        guard let url = URL(string: urlString) else { throw APIError.badURL }
        let session = URLSession(configuration: .default)

        /// Trying to get Data from Object URL
        let (data, _) = try await session.data(from: url)
        
        /// Trying to decode Data to JSON
        let decoded = try JSONDecoder().decode(Object.self, from: data)
        
        if let imageUrl = decoded.primaryImageSmall, !imageUrl.isEmpty {
            /// Checked for availability of public image and creating URL
            guard let url = URL(string: imageUrl) else { throw APIError.badURL}
            
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else { throw APIError.badImage}
            
            return image
        } else {
            /// Object is not public
            return nil
        }
    }
    
    
    /// End of APIManager class
}

enum APIError: Error {
    case badURL, badImage, objectsNil
    
    var description: String {
        switch self {
        case .badURL: return "Error handled: error of creating URL from String."
        case .badImage: return "Error handled: error of creating UIImage from Data."
        case .objectsNil: return "Error handled: empty array of object IDs."
        }
    }
}
