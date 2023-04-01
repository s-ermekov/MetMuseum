//
//  HideKeyboard.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 01.04.2023.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
