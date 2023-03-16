//
//  APIError.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 10.03.2023.
//

import Foundation

enum APIError: Error {
    case badURL
    case badImage
    case objectsNil
    case emptySearchText
    case badObject
    case nilUrlString
    case noPublicImages
    
    var description: String {
        switch self {
        case .badURL: return "Incorrect URL."
        case .badImage: return "No image found."
        case .objectsNil: return "No results were found. Please try again with another search keywords."
        case .emptySearchText: return "Empty search keyword. Please try again with another keywords."
        case .badObject: return "Incorrect data type of artwork data object."
        case .nilUrlString: return "No public image available for current artwork."
        case .noPublicImages: return "No results with public images were found. Please try with another search keywords."
        }
    }
}
