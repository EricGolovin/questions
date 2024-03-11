//
//  AppView.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

struct AppView: View {
    
    @StateObject private var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            StarView(navigation: navigation)
        }
    }
}
