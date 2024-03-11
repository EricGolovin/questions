//
//  StartView.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct StarView: View {
    
    private enum Destination {
        case questions
    }
    
    @EnvironmentObject private var viewModelFactory: ViewModelFactory
    
    private var navigation: Navigation
    
    init(navigation: Navigation) {
        self.navigation = navigation
    }
    
    var body: some View {
        HStack {
            PrimaryButton("Start Survey") {
                navigation.push(Destination.questions)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
        .navigationDestination(for: Destination.self) { destination in
            switch destination {
            case .questions:
                QuestionsView(viewModel: viewModelFactory.build(), navigation: navigation)
            }
        }
    }
}
