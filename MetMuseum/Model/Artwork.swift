//
//  Painting.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 08.03.2023.
//

import UIKit

struct Artwork {
    let id: Int
    let image: UIImage
    var objectData: Object
    
    /// Computed properties
    var width: Double { return image.size.width }
    var height: Double { return image.size.height }
    var portraitMode: Bool { return image.size.width < image.size.height + 50 }
    
    init(id: Int, image: UIImage, objectData: Object) {
        self.id = id
        self.image = image
        self.objectData = objectData
    }
}

extension Artwork {
    static func mock() -> Artwork {
        return Artwork(
            id: 436524,
            image: UIImage(named: "sunflowersSmall")!,
            objectData: Object.getDefault())
    }
}

extension Object {
    /// For Preview Usage
    static func getDefault() -> Object {
        var object = Object()
        
        guard let path = Bundle.main.path(forResource: "sunflowers", ofType: "json") else {
            return object
        }
        
        do {
            var data = Data()
            
            if #available(iOS 16.0, *) {
                data = try Data(contentsOf: URL(filePath: path))
            } else {
                data = try Data(contentsOf: URL(fileURLWithPath: path))
            }
            
            object = try JSONDecoder().decode(Object.self, from: data)
        } catch {
            print(error)
        }
        
        return object
    }
}
