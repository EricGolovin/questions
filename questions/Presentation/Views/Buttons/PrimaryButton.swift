//
//  PrimaryButton.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct PrimaryButton: View {
    
    let title: LocalizedStringKey
    let isEnabled: Bool
    let isLoading: Bool
    let action: (@MainActor () -> Void)?
    let asyncAction: (() async -> Void)?
    
    @State private var isPressed = false
    
    init(
        _ title: LocalizedStringKey,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
        self.asyncAction = nil
    }
    
    init(
        _ title: LocalizedStringKey,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        asyncAction: @escaping () async -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.asyncAction = asyncAction
        self.action = nil
    }
    
    var body: some View {
        Button {
            if let action {
                action()
            } else if let asyncAction {
                Task {
                    await asyncAction()
                }
            }
        } label: {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView()
                        .controlSize(.regular)
                } else {
                    Text(title)
                }
            }
        }
        .animation(.easeInOut(duration: 0.1), value: isLoading)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: .infinity) { pressing in
            isPressed = pressing
        } perform: {
        }
    }
}
