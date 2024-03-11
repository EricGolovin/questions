//
//  ParsingError.swift
//
//
//  Created by Yevhen Kharytonenko on 14/09/2023.
//

import Foundation

enum ParsingError: Error {
    case jsonConversionFailure(Error)
}
