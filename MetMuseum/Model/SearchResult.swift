//
//  SearchResult.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 11.03.2023.
//

import Foundation

struct SearchResult: Decodable {
    var total: Int
    var objectIDs: [Int]?
}
