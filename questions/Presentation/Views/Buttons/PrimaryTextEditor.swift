//
//  PrimaryTextEditor.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct PrimaryTextEditor: View {
    
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.title3)
                .foregroundStyle(.secondary)
                .focused($isFocused)
            
            if text.isEmpty, !isFocused {
                Text(placeholder)
                    .font(.title3)
                    .opacity(0.75)
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        isFocused = true
                    }
            }
        }
    }
}
