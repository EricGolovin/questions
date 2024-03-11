//
//  NetworkingError.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

enum NetworkingError: Error {
    case error(statusCode: HTTPStatusCode?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case invalidResponse
    case invalidStatusCode
    case jsonConversionFailure
}
