//
//  ViewModelContainer.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

final class ViewModelContainer: Container {
    
    private let dependencyResolver: Resolver
    
    private var factories: [ObjectIdentifier: Any] = [:]
    private var containerObjects: [ObjectIdentifier: Any] = [:]
    
    // MARK: Initializer
    
    init(dependencyResolver: Resolver) {
        self.dependencyResolver = dependencyResolver
        super.init()
    }
    
    // MARK: Public
    
    func register<T: ViewModel>(scope: ContainerScope, factory: @escaping @MainActor (any Resolver, T.Configuration) -> T) {
        let key = key(for: T.self)
        switch scope {
        case .transient:
            factories[key] = factory
        case .container:
            factories[key] = { @MainActor [weak self] resolver, configuration in
                if let instance = self?.containerObjects[key] {
                    return instance
                } else {
                    let instance = factory(resolver, configuration)
                    self?.containerObjects[key] = instance
                    return instance
                }
            }
        }
    }
    
    func resolve<T: ViewModel>(configuration: T.Configuration) -> T {
        guard let factory = factories[key(for: T.self)] as? (Resolver, T.Configuration) -> T else {
            fatalError("No factory found for \(T.self)")
        }
        return factory(self, configuration)
    }
    
    override func resolveDependency<T>() -> T {
        if T.self is any ViewModel.Type {
            super.resolveDependency()
        } else {
            dependencyResolver.resolveDependency()
        }
    }
    
    // MARK: Private
    
    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}
