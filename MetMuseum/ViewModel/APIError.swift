//
//  APIError.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 10.03.2023.
//

import Foundation

enum APIError: Error {
    case badURL, badImage, objectsNil, emptySearchText, badObject, nilString
    
    var description: String {
        switch self {
        case .badURL: return "Error handled: error of creating URL from String."
        case .badImage: return "Error handled: error of creating UIImage from Data."
        case .objectsNil: return "Error handled: empty array of object IDs."
        case .emptySearchText: return "Error handled: search text is empty."
        case .badObject: return "Error occured while object data unwrapping."
        case .nilString: return "Error handled. String is nil."
        }
    }
}
