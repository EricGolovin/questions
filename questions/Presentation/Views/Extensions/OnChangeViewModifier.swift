//
//  OnChangeViewModifier.swift
//
//
//  Created by Eric Golovin.
//

import SwiftUI

public extension View {

    func onChange<V>(of value: V, _ action: @escaping () async -> Void) -> some View where V: Equatable {
        onChange(of: value) {
            Task {
                await action()
            }
        }
    }
}
