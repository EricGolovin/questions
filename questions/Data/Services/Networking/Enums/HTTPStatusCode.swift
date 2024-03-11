//
//  HTTPStatusCode.swift
//
//
//  Created by Yevhen Kharytonenko on 17/09/2023.
//

import Foundation

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case notModified = 304
    case found = 302
    case seeOther = 303
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case serviceUnavailable = 503

    var isSuccess: Bool {
        switch self {
        case .ok, .created, .accepted, .noContent, .notModified:
            return true
        default:
            return false
        }
    }

    var isClientError: Bool {
        switch self {
        case .badRequest, .unauthorized, .forbidden, .notFound:
            return true
        default:
            return false
        }
    }

     var isServerError: Bool {
        switch self {
        case .internalServerError, .serviceUnavailable:
            return true
        default:
            return false
        }
    }
}
