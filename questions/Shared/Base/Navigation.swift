//
//  Navigation.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

final class Navigation: ObservableObject {
    
    @Published var path = NavigationPath()
    
    init() { }
    
    func push<T: Hashable>(_ value: T) {
        path.append(value)
    }
    
    func popLast() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
