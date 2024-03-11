//
//  RequestsFactory.swift
//
//
//  Created by Yevhen Kharytonenko on 14/09/2023.
//

import Foundation

final class RequestsFactory {

    // MARK: methods

    func urlRequest(for endpoint: EndpointProtocol, with configuration: NetworkingConfiguration) async throws -> URLRequest {
        let url = try url(for: endpoint, with: configuration)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = configuration.baseHeaders ?? [:]
        endpoint.headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }

        if let encodableBody = endpoint.bodyParametersEncodable, let data = encodeBody(encodableBody) {
            urlRequest.httpBody = data
        } else if !endpoint.bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: endpoint.bodyParameters, bodyEncoding: endpoint.bodyEncoding)
        }

        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }

    // MARK: Private methods

    private func url(for endpoint: EndpointProtocol, with configuration: NetworkingConfiguration) throws -> URL {
        let baseURL = configuration.baseURL.absoluteString.last != "/"
        ? (configuration.baseURL.absoluteString) + "/"
        : configuration.baseURL.absoluteString

        let endpointPath = baseURL.appending(endpoint.path)

        guard var urlComponents = URLComponents(string: endpointPath) else { throw RequestGenerationError.components }

        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try endpoint.queryParametersEncodable?.toDictionary() ?? endpoint.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        switch endpoint.queryEncodingType {
        case .regular:
            urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        case .percent:
            urlComponents.percentEncodedQueryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        }
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }

    private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingASCII:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }

    private func encodeBody(_ encodable: Encodable) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(encodable)
        } catch {
            return nil
        }
    }
}
