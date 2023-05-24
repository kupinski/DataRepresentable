//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation

/// When an object conforms to `DataRepresentable`, then this individual type as well as arrays of this type can be converted to `Data`
///
/// There is no checking that the representation in `Data` form is compatible across machines.  Endianness issues must be handled by the user when appropriate.
///
///  Anything that is `DataRepresentable` always uses `MemoryLayout<T>.stride` number of bytes.  This helps with compatibility with arrays of `DataRepresentable`.
public protocol DataRepresentable {
    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  The passed `atOffset` is marked as `inout` because the offset will be incremented based on the  number of bytes read.
    init?(fromData data: Data, atOffset: inout Int)

    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  Does not keeps track of the offset.
    init?(fromData data: Data)

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
        self.init(fromData: data)
    }
    
    public func write(toURL url: URL) throws {
        try self.dataRepresentation.write(to: url)
    }
    
}


