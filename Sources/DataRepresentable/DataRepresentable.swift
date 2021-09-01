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
    /// Convert the object to `Data`
    var dataRepresentation: Data { get }
    
    /// A static variable that describes the number of bytes allocated per entry
    static var dataStride: Int { get }
}


