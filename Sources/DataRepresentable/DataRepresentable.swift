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
    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  The passed `data` is marked as `inout` because the data that is parsed is then discraded from the front of the `Data` structure.  This allows the next set of elements to be parsed.
    ///
    /// > Important:  For `String`s we use null termination to find the end of strings in `Data`.  This is likely both unsafe and may fail in certain rare circumstances.
    /// 
    /// > Note: It might be safer to use a separate class for parsing `Data`; one that keeps track of where we are in the data structures instead of removing bytes.
    init?(fromData data: inout Data)
    
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
        var data = try Data(contentsOf: url)
        self.init(fromData: &data)
    }
    
    public func write(toURL url: URL) throws {
        try self.dataRepresentation.write(to: url)
    }
    
}


