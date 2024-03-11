//
//  NetworkingConfiguration.swift
//
//
//  Created by Yevhen Kharytonenko on 17/09/2023.
//

import Foundation

struct NetworkingConfiguration {

    var isBackground = false
    var baseURL: URL
    var baseHeaders: [String: String]?

    var urlSessionConfiguration: URLSessionConfiguration {
        var sessionConfiguration: URLSessionConfiguration
        if isBackground {
            sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "Questions.Networking")
        } else {
            sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.timeoutIntervalForRequest = 15
        }
        return sessionConfiguration
    }

    init(isBackground: Bool = false, baseURL: URL, headers: [String: String]? = nil) {
        self.isBackground = isBackground
        self.baseURL = baseURL
        self.baseHeaders = headers
    }
}
