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
    public init?(fromData data: Data, atOffset: inout Int) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        let value: Self = data.extractValue(atOffset: &atOffset)
        self = value
    }
    
    /// Initialze a single numeric value from `Data`
    /// - Parameter data: The data to convert into a numeric value.
    public init?(fromData data: Data) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        let value: Self = data.extractValue()
        self = value
    }
}

extension SIMD2 : DataRepresentable {}
extension SIMD3 : DataRepresentable {}
extension SIMD4 : DataRepresentable {}
extension SIMD8 : DataRepresentable {}
extension SIMD16 : DataRepresentable {}
extension SIMD32 : DataRepresentable {}
extension SIMD64 : DataRepresentable {}

