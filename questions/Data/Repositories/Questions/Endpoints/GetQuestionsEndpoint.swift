//
//  GetQuestionsEndpoint.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

struct GetQuestionsEndpoint: EndpointProtocol {
    let path = "questions"
    let method: HTTPMethod = .get
}
