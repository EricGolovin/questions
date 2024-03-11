//
//  PostSubmitQuestionEndpoint.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

struct PostSubmitQuestionEndpoint: EndpointProtocol {
    let path = "question/submit"
    let method: HTTPMethod = .post
    let bodyParametersEncodable: Encodable?
    
    init(model: QuestionAnswerRemoteDataModel) {
        bodyParametersEncodable = model
    }
}
