//
//  OnAppearViewModifier.swift
//
//
//  Created by Eric Golovin.
//

import SwiftUI

public extension View {

    func onAppear(action: @escaping () async -> Void) -> some View {
        modifier(AsyncOnAppearModifier(action: action))
    }
}

private struct AsyncOnAppearModifier: ViewModifier {

    let action: () async -> Void

    @State private var viewDidLoad = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    await action()
                }
            }
    }
}
