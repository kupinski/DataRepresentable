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

    
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init?(fromData data: inout Data) {
        self.init(fromData: &data, count: nil)
    }

    
    /// Create an array from `Data`
    ///
    /// For non-array types `data` only the first `MemoryLayout<Element>.stride` bytes are uesd.  For an `Array`, we assume that ALL of the passed `data` is meant to be converted into `[Element]`.
    /// - Parameter data: The `Data` to convert to an array.
    public init?(fromData data: inout Data, count: Int? = nil) {
        if (data.count < MemoryLayout<Element>.stride * (count ?? 1)) {
            return(nil)
        }
        let newCount = count ?? (data.count / MemoryLayout<Element>.stride)
        var bytesRead = 0
        self = Array(unsafeUninitializedCapacity: newCount,
                     initializingWith: {(buf, initCount) in
            bytesRead = data.copyBytes(to: buf)
            initCount = newCount
        })
        data = data.advanced(by: bytesRead)
    }
}






