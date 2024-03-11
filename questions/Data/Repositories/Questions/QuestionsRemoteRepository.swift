//
//  QuestionsRemoteRepository.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

final class QuestionsRemoteRepository: QuestionsUseCaseRepositoryProtocol {
    
    private let networkingService: NetworkingServiceProtocol
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
    
    func loadQuestions() async throws -> [QuestionEntity] {
        let endpoint = GetQuestionsEndpoint()
        let questions: [QuestionRemoteDataModel] = try await networkingService.executeRequest(endpoint: endpoint)
        return questions.map { QuestionEntity(id: $0.id, title: $0.question) }
    }
    
    func submitQuestion(id: Int, answer: String) async throws {
        do {
            let model = QuestionAnswerRemoteDataModel(id: id, answer: answer)
            let endpoint = PostSubmitQuestionEndpoint(model: model)
            try await networkingService.executeRequest(endpoint: endpoint)
        } catch let error as NetworkingError {
            if case .error(let statusCode) = error, statusCode == .badRequest {
                throw QuestionsUseCaseError.wrongAnswer
            }
        }
    }
}
