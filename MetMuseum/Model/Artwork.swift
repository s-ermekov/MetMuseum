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
    let objectData: Object
    
    init(id: Int, image: UIImage, objectData: Object) {
        self.id = id
        self.image = image
        self.objectData = objectData
    }
}
