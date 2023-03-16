//
//  FileManagerExtension.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 14.03.2023.
//

import Foundation

extension FileManager {
    static var keywordsPath: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let keywordsPath = URL(fileURLWithPath: "searchKeywords", relativeTo: path).appendingPathExtension("json")
        return keywordsPath
    }
}
