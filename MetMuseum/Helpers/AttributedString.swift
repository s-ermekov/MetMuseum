//
//  AttributedString.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 16.03.2023.
//

import UIKit

struct Attribute {
    let string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    var gray: AttributedString {
        var attributedString = AttributedString(string)
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.ForegroundColorAttribute.self] = .gray
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        return attributedString
    }
    
    var link: AttributedString {
        var attributedString = AttributedString(string)
        attributedString.link = URL(string: string)
        return attributedString
    }
    
    var semibold: AttributedString {
        var attributedString = AttributedString(string)
        var container = AttributeContainer()
        container[AttributeScopes.SwiftUIAttributes.FontAttribute.self] = .body.weight(.semibold)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        return attributedString
    }
    
}
