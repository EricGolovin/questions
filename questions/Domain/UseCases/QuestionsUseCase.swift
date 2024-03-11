//
//  QuestionsUseCase.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

protocol QuestionsUseCaseRepositoryProtocol {
    func loadQuestions() async throws -> [QuestionEntity]
    func submitQuestion(id: Int, answer: String) async throws
}

protocol QuestionsUseCaseProtocol {
    func provideModel(at index: Int) async throws -> QuestionsUseCaseResponseModel
    func submitQuestion(id: Int, answer: String) async throws -> QuestionsUseCaseResponseModel
}

enum QuestionsUseCaseError: Error {
    case noQuestionFound
    case wrongAnswer
}

actor QuestionsUseCase: QuestionsUseCaseProtocol {
    
    private let repository: QuestionsUseCaseRepositoryProtocol
    
    private var entities: [QuestionEntity] = []
    private var submittedQuestionIDs: [Int: String] = [:]
    
    init(repository: QuestionsUseCaseRepositoryProtocol) {
        self.repository = repository
    }
    
    func provideModel(at index: Int) async throws -> QuestionsUseCaseResponseModel {
        if entities.isEmpty {
            entities = try await repository.loadQuestions()
        }
        
        guard index < entities.count else {
            throw QuestionsUseCaseError.noQuestionFound
        }
        
        let entity = entities[index]
        return responseModel(for: entity)
    }
    
    func submitQuestion(id: Int, answer: String) async throws -> QuestionsUseCaseResponseModel {
        guard let entity = entities.first(where: { $0.id == id }) else {
            throw QuestionsUseCaseError.noQuestionFound
        }
        try await repository.submitQuestion(id: id, answer: answer)
        submittedQuestionIDs[id] = answer
        return responseModel(for: entity)
    }
    
    private func responseModel(for entity: QuestionEntity) -> QuestionsUseCaseResponseModel {
        let question = QuestionsUseCaseResponseModel.Question(entity, answer: submittedQuestionIDs[entity.id])
        return QuestionsUseCaseResponseModel(
            totalQuestions: entities.count,
            totalSubmittedQuestions: submittedQuestionIDs.count,
            question: question
        )
    }
}
