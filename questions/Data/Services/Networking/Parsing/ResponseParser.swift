//
//  ResponseParser.swift
//
//
//  Created by Yevhen Kharytonenko on 14/09/2023.
//

import Foundation

final class ResponseParser {

    func parseResponse<T>(data: Data) throws -> T where T: Decodable, T: Encodable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as NSError {
            throw ParsingError.jsonConversionFailure(error)
        }
    }
}
