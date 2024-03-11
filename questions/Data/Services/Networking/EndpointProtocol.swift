//
//  EndpointProtocol.swift
//
//
//  Created by Yevhen Kharytonenko on 13/09/2023.
//

import Foundation

protocol EndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var queryEncodingType: QueryEncodingType { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
}

extension EndpointProtocol {
    var headerParameters: [String: String] { [:] }
    var queryParametersEncodable: Encodable? { nil }
    var queryParameters: [String: Any] { [:]  }
    var queryEncodingType: QueryEncodingType { .regular }
    var bodyParametersEncodable: Encodable? { nil }
    var bodyParameters: [String: Any] { [:]  }
    var bodyEncoding: BodyEncoding { .jsonSerializationData }
}
