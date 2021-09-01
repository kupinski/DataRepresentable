//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation
import simd

extension SIMD  {
    /// Convert a numeric value to `Data`.
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }

    public init(fromData data: Data) {
        self =  data.withUnsafeBytes( {$0.load(as: Self.self)})
    }
    
    /// The dataStride for the `DataRepresentable`.
    static public var dataStride: Int {
        return MemoryLayout< Self >.stride
    }
}

//extension SIMD where Self.Scalar : FixedWidthInteger {
//    /// Convert a numeric value to `Data`.
//    public var dataRepresentation: Data {
//        var source = self
//        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
//    }
//
//
//    /// Initialze a single numeric value from `Data`
//    public init(fromData data: Data) {
//        var value: Self = Self.zero
//        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
//        assert(size == MemoryLayout.size(ofValue: value))
//        self = value
//    }
//
//    /// The dataStride for the `DataRepresentable`.
//    static public var dataStride: Int {
//        return MemoryLayout< Self >.stride
//    }
//}

//extension SIMD3: DataRepresentable   {}
//extension SIMD2: DataRepresentable {}


