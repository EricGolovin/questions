//
//  NetworkingService.swift
//
//
//  Created by Yevhen Kharytonenko on 13/09/2023.
//

import Foundation

protocol NetworkingServiceProtocol {
    func loadData(url: URL) async throws -> Data
    func load<T: Codable>(with request: URLRequest) async throws -> T
    func load(with request: URLRequest) async throws
    func executeRequest<V: EndpointProtocol, T: Codable>(endpoint: V) async throws -> T
    func executeRequest<V: EndpointProtocol>(endpoint: V) async throws
}

actor NetworkingService: NetworkingServiceProtocol {

    private typealias SessionDataResponse = (data: Data, response: URLResponse)

    private let configuration: NetworkingConfiguration
    private let session: URLSession
    private let requestFactory = RequestsFactory()
    private let responseParser = ResponseParser()

    init(networkingConfiguration: NetworkingConfiguration) {
        self.configuration = networkingConfiguration
        self.session = URLSession(configuration: networkingConfiguration.urlSessionConfiguration)
    }

    deinit {
        session.finishTasksAndInvalidate()
    }

    // MARK: Public

    func loadData(url: URL) async throws -> Data {
        let sessionDataResponse: SessionDataResponse
        do {
            sessionDataResponse = try await session.data(from: url)
        } catch {
            throw NetworkingError.cancelled
        }

        try handleURLResponse(sessionDataResponse.response, data: sessionDataResponse.data)
        return sessionDataResponse.data
    }

    func load<T: Codable>(with request: URLRequest) async throws -> T {
        let sessionDataResponse: SessionDataResponse
        do {
            sessionDataResponse = try await session.data(for: request)
        } catch {
            throw NetworkingError.cancelled
        }

        try handleURLResponse(sessionDataResponse.response, data: sessionDataResponse.data)
        do {
            return try responseParser.parseResponse(data: sessionDataResponse.data)
        } catch {
            throw NetworkingError.jsonConversionFailure
        }
    }

    func load(with request: URLRequest) async throws {
        let sessionDataResponse: SessionDataResponse
        do {
            sessionDataResponse = try await session.data(for: request)
        } catch {
            throw NetworkingError.cancelled
        }
        try handleURLResponse(sessionDataResponse.response, data: sessionDataResponse.data)
    }

    func executeRequest<V: EndpointProtocol, T: Codable>(endpoint: V) async throws -> T {
        guard let urlRequest = try? await requestFactory.urlRequest(for: endpoint, with: configuration) else {
            throw NetworkingError.urlGeneration
        }
        return try await load(with: urlRequest)
    }

    @MainActor
    func executeRequest<V: EndpointProtocol>(endpoint: V) async throws {
        guard let urlRequest = try? await requestFactory.urlRequest(for: endpoint, with: configuration) else {
            throw NetworkingError.urlGeneration
        }
        try await load(with: urlRequest)
    }

    // MARK: Private methods

    private func handleURLResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }

        guard let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
            throw NetworkingError.invalidStatusCode
        }

        guard statusCode.isSuccess else {
            throw NetworkingError.error(statusCode: statusCode)
        }
    }
}
