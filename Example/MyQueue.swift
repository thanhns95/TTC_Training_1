//
//  MyQueue.swift
//  Example
//
//  Created by admin on 1/5/21.
//

import Foundation

class Queue<T> {
    private var elements: [T] = []
    let queue = DispatchQueue(label: "abc")
    let semaphore = DispatchSemaphore(value: 1)
    var lock = NSLock()
    func pushDispatch(_ element: T) {
        
        queue.async (flags: .barrier) {
            self.elements.append(element)
        }
            
    }
    
    func popDispatch() -> T? {
        queue.sync (flags: .barrier) {
            if self.elements.isEmpty {
                return nil
            }
            
            return self.elements.removeFirst()
        }
    }
    
    func pushSemaphore(_ element: T) {
        semaphore.wait()
        self.elements.append(element)
        semaphore.signal()
    }
    
    func popSemaphore() -> T? {
        semaphore.wait()
        if self.elements.isEmpty {
            return nil
        }
        let result = self.elements.removeFirst()
        semaphore.signal()
        return result
    }
    
    func pushLock(_ element: T) {
        lock.lock()
        self.elements.append(element)
        lock.unlock()
    }
    
    func popLock() -> T? {
        lock.lock()
        let result = self.elements.removeFirst()
        lock.unlock()
        return result
    }
}
