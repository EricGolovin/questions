//
//  Container.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

protocol Resolver {
    func resolveDependency<T>() -> T
}

enum ContainerScope {
    /// Create a new instance on each call.
    case transient
    
    /// Create only a single instance and cache it.
    case container
}

class Container: NSObject, Resolver {
    
    private var factories: [ObjectIdentifier: (Resolver) -> Any] = [:]
    private var containerObjects: [ObjectIdentifier: Any] = [:]
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Public
    
    func register<T>(scope: ContainerScope, factory: @escaping (Resolver) -> T) {
        let key = key(for: T.self)
        switch scope {
        case .transient:
            factories[key] = factory
        case .container:
            factories[key] = { [weak self] resolver in
                if let instance = self?.containerObjects[key] {
                    return instance
                } else {
                    let instance = factory(resolver)
                    self?.containerObjects[key] = instance
                    return instance
                }
            }
        }
    }
    
    func resolveDependency<T>() -> T {
        guard let factory = factories[key(for: T.self)] else {
            fatalError("No factory found for \(T.self)")
        }
        return factory(self) as! T // swiftlint:disable:this force_cast
    }
    
    // MARK: Private
    
    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
    
    private func dynamicallyInvokeRegistrationMethods() {
        var methodsCount: UInt32 = 0
        guard let methodsList = class_copyMethodList(Self.self, &methodsCount) else { return }
        let bufferPointer = UnsafeBufferPointer(start: methodsList, count: Int(methodsCount))
        for method in bufferPointer {
            let methodName = method_getName(method).description
            if methodName.contains("register") {
                perform(NSSelectorFromString(methodName))
            }
        }
        free(methodsList)
    }
}
