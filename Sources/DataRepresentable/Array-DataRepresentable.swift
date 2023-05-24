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


/// If an array is one of `ArrayToDataRepresentable`, then the array itself is `DataRepresentable`
extension Array: DataRepresentable where Element: DataRepresentable {
    /// Convert an array to `Data`
    public var dataRepresentation: Data {
        var count = self.count
        let data1 = Data(bytes: &count, count: MemoryLayout<Int>.stride)
        let data2 = Data(bytes: self, count: MemoryLayout<Element>.stride * self.count)
        return data1 + data2
    }

    
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init?(fromData data: Data, atOffset: inout Int) {
        let count: Int = data.extractValue(atOffset: &atOffset)
        self = data.extractArray(count: count, atOffset: &atOffset)
    }
    
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init?(fromData data: Data) {
        let count: Int = data.extractValue()
        let subData = data.subdata(in: MemoryLayout<Int>.stride..<(MemoryLayout<Int>.stride + MemoryLayout<Element>.stride * count))
        self = subData.extractArray(count: count)
    }

}







