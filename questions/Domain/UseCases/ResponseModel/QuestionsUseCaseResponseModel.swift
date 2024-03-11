//
//  QuestionsUseCaseResponseModel.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

struct QuestionsUseCaseResponseModel {
    
    struct Question {
        let id: Int
        let title: String
        let answer: String?
    }
    
    let totalQuestions: Int
    let totalSubmittedQuestions: Int
    let question: Question
}

extension QuestionsUseCaseResponseModel.Question {
    
    init(_ entity: QuestionEntity, answer: String?) {
        self.id = entity.id
        self.title = entity.title
        self.answer = answer
    }
}
