//
//  OnDisappearViewModifier.swift
//
//
//  Created by Eric Golovin.
//

import Foundation
import SwiftUI

public extension View {

    func onDisappear(action: @escaping () async -> Void) -> some View {
        modifier(AsyncOnDisappearModifier(action: action))
    }
}

private struct AsyncOnDisappearModifier: ViewModifier {

    let action: () async -> Void

    @State private var viewDidLoad = false

    func body(content: Content) -> some View {
        content
            .onDisappear {
                Task {
                    await action()
                }
            }
    }
}
