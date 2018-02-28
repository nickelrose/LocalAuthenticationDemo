//
//  Iteratable.swift
//  LocalAuthenticationDemo
//
//  Created by Nicholas Rose on 2/27/18.
//  Copyright © 2018 Nicholas Rose. All rights reserved.
//

import Foundation

/// Protocol that allows iteratine through hash and raw values of a collection
protocol Iteratable {}

extension RawRepresentable where Self: RawRepresentable {
    
    /// Loops through an enum
    ///
    /// - Parameter _: Enum for iterating
    /// - Returns: Enum iterator
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
}

// MARK: - Extension for accessing hash and raw values of a collection
extension Iteratable where Self: RawRepresentable, Self: Hashable {
    /// Returns an iterator over the hash values of a colleciton
    ///
    /// - Returns: Iterator
    static func hashValues() -> AnyIterator<Self> {
        return iterateEnum(self)
    }
    
    /// Returns raw values of a collection
    ///
    /// - Returns: Array of raw values
    static func rawValues() -> [Self.RawValue] {
        return hashValues().map({$0.rawValue})
    }
}
