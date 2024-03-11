//
//  QuestionsApp.swift
//  questions
//
//  Created by Eric Golovin.
//

import SwiftUI

@main
struct QuestionsApp: App {
    
    private let viewModelFactory: ViewModelFactory
    
    @MainActor
    init() {
        self.viewModelFactory = Self.configureViewModelFactory()
        setUpAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(viewModelFactory)
        }
    }
    
    @MainActor
    private func setUpAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}

extension QuestionsApp {
    
    @MainActor
    private static func configureViewModelFactory() -> ViewModelFactory {
        let dependencyResolver = configureDependencyContainer()
        let container = ViewModelContainer(dependencyResolver: dependencyResolver)
        container.register(scope: .transient) { resolver in
            let repository = QuestionsRemoteRepository(networkingService: resolver.resolveDependency())
            let useCase = QuestionsUseCase(repository: repository)
            return QuestionsViewModel(useCase: useCase)
        }
        
        return ViewModelFactory(viewModelContainer: container)
    }
    
    @MainActor
    private static func configureDependencyContainer() -> Container {
        let container = Container()
        container.register(scope: .container) { _ -> EnvironmentManagerProtocol in
            return EnvironmentManager()
        }
        container.register(scope: .container) { resolver -> NetworkingServiceProtocol in
            let environmentManager: EnvironmentManagerProtocol = resolver.resolveDependency()
            let configuration = NetworkingConfiguration(baseURL: environmentManager.current.baseURL)
            return NetworkingService(networkingConfiguration: configuration)
        }
        
        return container
    }
}
