//
//  Coordinator.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 24/10/2020.
//

import Foundation

class Coordinator: NSObject {
    
    var shouldEnd: (() -> Void)?
    
    private(set) var coordinators = [Coordinator]()
        
    func push(childCoordinator: Coordinator) {
        coordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    @discardableResult
    func pop(childCoordinator: Coordinator) -> Coordinator? {
        if let index = coordinators.firstIndex(of: childCoordinator) {
            childCoordinator.coordinatorWillEnd()
            return coordinators.remove(at: index)
        } else {
            return nil
        }
    }
    
    func start() {
        // To be overriden
    }
    
    
    /// This method will be called before coordinator is removed from the stack.
    /// Use this method to clean view hierarchy
    func coordinatorWillEnd() {
        
    }
}
