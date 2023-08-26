//
//  ViewExtensions.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 28.02.23.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension Array {
    /// Union with newElements, comparing by keyPath value and replacing old elements with new
    /// Expected complexity ~ 3*n
    func union<T: Hashable>(newElements: Array, byKeyPath keyPath: KeyPath<Element, T>) -> Array {
        var copy = self
        // Hash indices for faster replacement
        let sample = copy.enumerated().reduce(into: [T: Index]()) { result, entry in
            result[entry.element[keyPath: keyPath]] = entry.offset
        }
        copy.reserveCapacity(copy.count + newElements.count)
        // Either replace element if it is `equal` or append to the end
        for element in newElements {
            if let index = sample[element[keyPath: keyPath]] {
                copy[index] = element
            } else {
                copy.append(element)
            }
        }
        return copy
    }
}
