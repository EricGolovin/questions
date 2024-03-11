//
//  OnLoadViewModifier.swift
//
//
//  Created by Eric Golovin.
//

import SwiftUI

public extension View {
    func onLoad(action: @escaping () -> Void) -> some View {
        modifier(OnLoadModifier(action: action))
    }

    func onLoad(action: @escaping () async -> Void) -> some View {
        modifier(AsyncOnLoadModifier(action: action))
    }
}

private struct OnLoadModifier: ViewModifier {

    let action: () -> Void

    @State private var viewDidLoad = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !viewDidLoad {
                    viewDidLoad = true
                    action()
                }
            }
    }
}

private struct AsyncOnLoadModifier: ViewModifier {

    let action: () async -> Void

    @State private var viewDidLoad = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !viewDidLoad {
                    viewDidLoad = true
                    Task {
                        await action()
                    }
                }
            }
    }
}
