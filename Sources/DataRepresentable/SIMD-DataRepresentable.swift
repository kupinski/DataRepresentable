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
    
    /// Convert `data` into a `SIMD` strucutre.
    /// - Parameter data: The data to parse.  Note that the used portion of `data` is removed so that the next bytes can be processed.
    public init?(fromData data: inout Data) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        self =  data.withUnsafeBytes( {$0.load(as: Self.self)})
        data = data.advanced(by: MemoryLayout<Self>.stride)
    }
    
}

extension SIMD2 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD3 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD4 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD8 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD16 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD32 : DataRepresentable, ArrayToDataRepresentable {}
extension SIMD64 : DataRepresentable, ArrayToDataRepresentable {}

