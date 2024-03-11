//
//  Environment.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

enum Environment: String, CaseIterable {
    case development = "Development"
    
    var baseURL: URL {
        switch self {
        case .development:
            URL(string: "https://xm-assignment.web.app")! // swiftlint:disable:this force_unwrapping
        }
    }
}
