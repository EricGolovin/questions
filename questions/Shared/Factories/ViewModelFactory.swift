//
//  ViewModelFactory.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

final class ViewModelFactory: ObservableObject {
    
    private let viewModelContainer: ViewModelContainer
    
    init(viewModelContainer: ViewModelContainer) {
        self.viewModelContainer = viewModelContainer
    }
    
    func build<T: ViewModel>() -> T {
        viewModelContainer.resolveDependency()
    }
    
    func build<T: ViewModel>(with configuration: T.Configuration) -> T {
        viewModelContainer.resolve(configuration: configuration)
    }
}
