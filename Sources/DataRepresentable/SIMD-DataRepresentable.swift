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

    public init?(fromData data: inout Data) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        self =  data.withUnsafeBytes( {$0.load(as: Self.self)})
        data = data.advanced(by: MemoryLayout<Self>.stride)
    }
    
}

extension SIMD2 : DataRepresentable {}
extension SIMD3 : DataRepresentable {}
extension SIMD4 : DataRepresentable {}
extension SIMD8 : DataRepresentable {}
extension SIMD16 : DataRepresentable {}
extension SIMD32 : DataRepresentable {}
extension SIMD64 : DataRepresentable {}

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


