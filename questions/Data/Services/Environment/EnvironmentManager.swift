//
//  EnvironmentManager.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

protocol EnvironmentManagerProtocol {
    var current: Environment { get }
}

final class EnvironmentManager: EnvironmentManagerProtocol {
    
    var current: Environment {
        return .development
    }
}
