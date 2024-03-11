//
//  QuestionsViewModel.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

final class QuestionsViewModel: BaseViewModel<Void> {
    
    enum State {
        case loading
        case success(questionID: Int)
    }
    
    @Published var answerText = ""
    @Published var isSubmitting = false
    @Published var state = State.loading
    
    private(set) var title = ""
    private(set) var submittedTitle = ""
    private(set) var questionTitle = ""
    private(set) var isSubmissionEnabled = true
    private(set) var isPreviousEnabled = false
    private(set) var isNextEnabled = true
    
    private let useCase: QuestionsUseCaseProtocol
    
    private var currentQuestionIndex = Int.zero
    
    @MainActor
    init(useCase: QuestionsUseCaseProtocol) {
        self.useCase = useCase
    }
    
    override func onLoad() async {
        await super.onLoad()
        await loadQuestion(at: currentQuestionIndex)
    }
    
    func previousTapped() async {
        await resetStatusTask()
        await loadQuestion(at: currentQuestionIndex - 1)
    }
    
    func nextTapped() async {
        await resetStatusTask()
        await loadQuestion(at: currentQuestionIndex + 1)
    }
    
    func submitTapped() async {
        guard case .success(let questionID) = state else { return }
        await submitQuestion(id: questionID)
    }
    
    @MainActor
    private func loadQuestion(at index: Int) async {
        do {
            let responseModel = try await useCase.provideModel(at: index)
            currentQuestionIndex = index
            updateUI(with: responseModel)
        } catch {
            handleUnknownError { [weak self] in
                await self?.loadQuestion(at: index)
            }
        }
    }
    
    @MainActor 
    func submitQuestion(id: Int) async {
        do {
            isSubmitting = true
            let responseModel = try await useCase.submitQuestion(id: id, answer: answerText)
            setStatusValue(.success)
            updateUI(with: responseModel)
        } catch {
            handleUnknownError { [weak self] in
                await self?.submitQuestion(id: id)
            }
        }
        isSubmitting = false
    }
    
    @MainActor
    private func updateUI(with responseModel: QuestionsUseCaseResponseModel) {
        let questionNum = currentQuestionIndex + 1
        title = "Question \(questionNum)/\(responseModel.totalQuestions)"
        submittedTitle = "Questions Submitted: \(responseModel.totalSubmittedQuestions)"
        questionTitle = "\(responseModel.question.title)"
        answerText = responseModel.question.answer ?? ""
        isSubmissionEnabled = responseModel.question.answer == nil
        isPreviousEnabled = currentQuestionIndex > .zero
        isNextEnabled = currentQuestionIndex < responseModel.totalQuestions - 1
        
        state = .success(questionID: responseModel.question.id)
    }
}
