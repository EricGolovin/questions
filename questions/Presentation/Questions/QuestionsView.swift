//
//  QuestionsView.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct QuestionsView: View {
    
    @StateObject private var viewModel: QuestionsViewModel
    private var navigation: Navigation
    
    init(viewModel: QuestionsViewModel, navigation: Navigation) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigation = navigation
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .controlSize(.regular)
            case .success:
                contentView
            }
        }
        .onLoad {
            await viewModel.onLoad()
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    PrimaryButton("Previous") {
                        await viewModel.previousTapped()
                    }
                    .disabled(!viewModel.isPreviousEnabled)
                    
                    PrimaryButton("Next") {
                        await viewModel.nextTapped()
                    }
                    .disabled(!viewModel.isNextEnabled)
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: .zero) {
            if let statusValue = viewModel.statusValue {
                StatusView(state: StatusView.State(statusValue))
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    TopBarView(title: viewModel.submittedTitle)
                    QuestionView(
                        answerText: $viewModel.answerText,
                        title: viewModel.questionTitle,
                        isSubmissionEnabled: viewModel.isSubmissionEnabled,
                        isSubmitting: viewModel.isSubmitting
                    ) {
                        await viewModel.submitTapped()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

private struct TopBarView: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(UIColor.systemGray6))
    }
}

private struct QuestionView: View {
    
    @Binding var answerText: String
    
    let title: String
    let isSubmissionEnabled: Bool
    let isSubmitting: Bool
    let submissionAction: @MainActor () async -> Void
    
    private var submissionButtonTitle: LocalizedStringKey {
        isSubmissionEnabled ? "Submit" : "Already Submitted"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                Spacer()
            }
            PrimaryTextEditor(text: $answerText, placeholder: "Type here for an answer...")
                .frame(height: 160)
            PrimaryButton(submissionButtonTitle, isEnabled: isSubmissionEnabled, isLoading: isSubmitting) {
                await submissionAction()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
    }
}

extension StatusView.State {
    
    init(_ value: QuestionsViewModel.StatusValue) {
        switch value {
        case .success:
            self = .success
        case .failure(let action):
            self = .failure(retryAction: action)
        }
    }
}
