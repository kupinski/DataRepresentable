//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation
import simd

public enum DataRepresentableError: Error {
    case notEnoughBytes
    case classRepresentationNotSpecified
    case invalidString
    case unexpected(case: Int)
}

extension DataRepresentableError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notEnoughBytes: return("Data stream doesn't contain sufficient length to read in data")
        case .classRepresentationNotSpecified: return("Class types must override dataRepresentation and initializers.  Defaults will not work.")
        case .invalidString: return("The Data has an invalid string representation.")
        case .unexpected(_): return("An unexpected error occured")
        }
    }
}


/// When an object conforms to `DataRepresentable`, then this individual type as well as arrays of this type can be converted to `Data`
///
/// There is no checking that the representation in `Data` form is compatible across machines.  Endianness issues must be handled by the user when appropriate.
///
///  Anything that is `DataRepresentable` always uses `MemoryLayout<T>.stride` number of bytes.  This helps with compatibility with arrays of `DataRepresentable`.
public protocol DataRepresentable {
    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  The passed `atOffset` is marked as `inout` because the offset will be incremented based on the  number of bytes read.
    init(fromData data: Data, atOffset: inout Int) throws

    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  Does not keeps track of the offset.
    init(fromData data: Data) throws

    /// Convert the object to `Data`
    var dataRepresentation: Data { get }

    
    /// Create a `DataRepresentable` from a file.
    ///
    /// Has a default implementation.  Assumes that the entire file is meant for the `DataRepresentable`.  Any extra bytes in the file are ignored.
    /// - Parameter url: The file `URL` to open and read into a `Data` structure.
    init?(fromURL url: URL) throws
    
    /// Write the `DataRepresentable` to a file.
    ///
    /// Has a default implementation.
    /// - Parameter url: The `URL` to write the file to.
    func write(toURL url: URL) throws


}


extension DataRepresentable {
    public init?(fromURL url: URL) throws {
        let data = try Data(contentsOf: url)
        let uncompressed = try(data as NSData).decompressed(using: .lzfse) as Data
        
        try self.init(fromData: uncompressed)
    }
    
    public func write(toURL url: URL) throws {
        let compressedData = try (self.dataRepresentation as NSData).compressed(using: .lzfse)
        try compressedData.write(to: url)
    }
    
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }
    
    public init(fromData data: Data, atOffset: inout Int) throws {
        if ((data.count - atOffset) < MemoryLayout<Self>.stride) {
            throw DataRepresentableError.notEnoughBytes
        }
        let value: Self = data.extractValue(atOffset: &atOffset)
        self = value
        if (type(of: self) is AnyClass) {
            throw DataRepresentableError.classRepresentationNotSpecified
        }
    }
    
    public init(fromData data: Data) throws {
        if (data.count < MemoryLayout<Self>.stride) {
            throw DataRepresentableError.notEnoughBytes
        }
        let value: Self = data.extractValue()
        self = value
        if (type(of: self) is AnyClass) {
            throw DataRepresentableError.classRepresentationNotSpecified
        }
    }
    
}


extension Float: DataRepresentable {}
extension Double: DataRepresentable {}
extension CGFloat: DataRepresentable {}

extension Int: DataRepresentable {}
extension Int64: DataRepresentable {}
extension Int32: DataRepresentable {}
extension Int16: DataRepresentable {}
extension Int8: DataRepresentable {}

extension UInt: DataRepresentable {}
extension UInt64: DataRepresentable {}
extension UInt32: DataRepresentable {}
extension UInt16: DataRepresentable {}
extension UInt8: DataRepresentable {}

extension SIMD2 : DataRepresentable {}
extension SIMD3 : DataRepresentable {}
extension SIMD4 : DataRepresentable {}
extension SIMD8 : DataRepresentable {}
extension SIMD16 : DataRepresentable {}
extension SIMD32 : DataRepresentable {}
extension SIMD64 : DataRepresentable {}

extension simd_float4x4: DataRepresentable {}
extension simd_bool: DataRepresentable {}

