//
//  Departments.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 07.03.2023.
//

import Foundation

struct Department: Hashable {
    let departmentId: Int
    let displayName: String
    
    static let departments: [Department] = [
        Department(departmentId: 1, displayName: "American Decorative Arts"),
        Department(departmentId: 3, displayName: "Ancient Near Eastern Art"),
        Department(departmentId: 4, displayName: "Arms and Armor"),
        Department(departmentId: 5, displayName: "Arts of Africa, Oceania, and the Americas"),
        Department(departmentId: 6, displayName: "Asian Art"),
        Department(departmentId: 7, displayName: "The Cloisters"),
        Department(departmentId: 8, displayName: "The Costume Institute"),
        Department(departmentId: 9, displayName: "Drawings and Prints"),
        Department(departmentId: 10, displayName: "Egyptian Art"),
        Department(departmentId: 11, displayName: "European Paintings"),
        Department(departmentId: 12, displayName: "European Sculpture and Decorative Arts"),
        Department(departmentId: 13, displayName: "Greek and Roman Art"),
        Department(departmentId: 14, displayName: "Islamic Art"),
        Department(departmentId: 15, displayName: "The Robert Lehman Collection"),
        Department(departmentId: 16, displayName: "The Libraries"),
        Department(departmentId: 17, displayName: "Medieval Art"),
        Department(departmentId: 18, displayName: "Musical Instruments"),
        Department(departmentId: 19, displayName: "Photographs"),
        Department(departmentId: 21, displayName: "Modern Art")
    ]
}


