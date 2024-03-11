//
//  StatusView.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct StatusView: View {
    
    enum State {
        case success
        case failure(retryAction: () async -> Void)
    }
    
    let state: State
    
    private var title: String {
        switch state {
        case .success:
            "Success"
        case .failure:
            "Failure!"
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .success:
                .green
        case .failure:
                .red
        }
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
            
            Spacer()
            
            switch state {
            case .success:
                EmptyView()
            case .failure(let retryAction):
                PrimaryButton("RETRY") {
                    await retryAction()
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(
                        cornerRadius: 2,
                        style: .continuous
                    )
                    .stroke(.white, lineWidth: 2)
                    
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(backgroundColor)
    }
}
