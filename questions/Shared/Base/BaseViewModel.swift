//
//  BaseViewModel.swift
//  questions
//
//  Created by Eric Golovin.
//

import Foundation

protocol ViewModel: Configurable { }

class BaseViewModel<T>: ObservableObject, ViewModel {
    
    typealias Configuration = T
    
    
    enum StatusValue {
        case success
        case failure(action: () async -> Void)
    }
    
    @Published var statusValue: StatusValue?
    
    private var delayedStatusTask: Task<(), Never>?
    
    init() {
        
    }
    
    @MainActor
    open func onLoad() async {
        
    }
    
    @MainActor
    open func onAppear() async {
        
    }
    
    @MainActor
    open func onDisappear() async {
        
    }
    
    @MainActor
    func handleUnknownError(retryAction: @escaping () async -> Void) {
        resetStatusTask()
        setStatusValue(.failure(action: retryAction))
    }
    
    @MainActor
    func setStatusValue(_ value: StatusValue) {
        statusValue = value
        delayedStatusTask = Task { @MainActor [weak self] in
            let threeSeconds: UInt64 = 3_000_000_000
            try? await Task.sleep(nanoseconds: threeSeconds)
            if !Task.isCancelled {
                self?.statusValue = .none
            }
        }
    }
    
    @MainActor
    func resetStatusTask() {
        delayedStatusTask?.cancel()
        statusValue = .none
    }
}
