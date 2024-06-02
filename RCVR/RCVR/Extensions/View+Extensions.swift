//
//  View+Extensions.swift
//  RCVR
//
//  Created by richard Haynes on 6/1/24.
//

import Foundation
import SwiftUI
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
