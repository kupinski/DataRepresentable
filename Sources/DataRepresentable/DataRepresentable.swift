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
///  To conform to individual elements as well as array being `DataRepresentable`, we use the `MemoryLayout<T>.size` command when converting individual elements into `Data` and use `MemoryLayout<T>.size` to size elements in an array. 
public protocol DataRepresentable {
    /// Create a `DataRepresentable` from `Data`.  
    init?(fromData data: inout Data)
    
    /// Create a `DataRepresentable` from a file.
    ///
    /// Has a default implementation.  Assumes that the entire file is meant for the `DataRepresentable`.  Any extra bytes in the file are ignored.
    init?(fromURL url: URL) throws
    
    /// Write the `DataRepresentable` to a file.
    ///
    /// Has a default implementation.
    func write(toURL url: URL) throws


    /// Convert the object to `Data`
    var dataRepresentation: Data { get }
}


extension DataRepresentable {
    public init?(fromURL url: URL) throws {
        var data = try Data(contentsOf: url)
        self.init(fromData: &data)
    }
    
    public func write(toURL url: URL) throws {
        try self.dataRepresentation.write(to: url)
    }
    
}


