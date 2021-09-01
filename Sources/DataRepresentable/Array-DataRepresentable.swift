//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation

/// If an array is one of `DataRepresentable`, then it is also `DataRepresentable`
extension Array: DataRepresentable where Element: DataRepresentable {
    /// Convert an array to `Data`
    public var dataRepresentation: Data {
        return .init(bytes: self, count: MemoryLayout<Element>.stride * self.count)
    }
    
    /// The stride is always of an element???
    public static var dataStride: Int {
        return Element.dataStride
    }
    
    
    /// Create an array from `Data`
    /// - Parameter data: The `Data` to convert to an array
    public init(fromData data: Data) {
        let newCount = data.count / MemoryLayout<Element>.stride
        self = Array(unsafeUninitializedCapacity: newCount,
                     initializingWith: {(buf, initCount) in
            _ = data.copyBytes(to: buf)
            initCount = newCount
        })
    }
}




