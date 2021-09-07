//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation

/// A protocol that restricts the types of variables that can be ``DataRepresentable`` in an `Array`.
///
/// Currently, simple arrays of basic types like `Int`, `Double`,  or `SIMD3<Float>` can be represented as `Data` using ``DataRepresentable``.  This contraint is largely due to the simple nature of the `Data` representation.  For example, with an array of an array of `Float`, there is no way of telling when a sub-array ends and the next array begins without a more complicated data structure.  Similarly, and Array of `String` is not supported since strings can have variable size and we would need to parse them one by one to extract the array of `String` values.
///
/// This protocol is currently empty and it is assumed that for whatever strucutre adheres to `ArrayToDataRepresentable` that `MemoryLayout< Type >.stride` is a fixed stride for any realization of that type.  This works for `Double`, etc.
public protocol ArrayToDataRepresentable : DataRepresentable {
}


/// If an array is one of `ArrayToDataRepresentable`, then the array itself is `DataRepresentable`
extension Array: DataRepresentable where Element: ArrayToDataRepresentable {
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
    /// - Parameters:
    ///    - data:  The `Data` to convert to an array.
    ///    - count: The number of elements in the array to read from `data`.  If `nil`, then the entirety of `data` will be converted to the array.  Any bytes left over will remain in the `inout` data.
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






