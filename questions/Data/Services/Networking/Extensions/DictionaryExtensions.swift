//
//  DictionaryExtensions.swift
//  
//
//  Created by Yevhen Kharytonenko on 17/09/2023.
//

import Foundation

extension Dictionary {
    var queryString: String {
        self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}
