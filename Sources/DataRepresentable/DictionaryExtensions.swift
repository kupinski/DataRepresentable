//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation



extension Dictionary: DataRepresentable where Key: DataRepresentable, Value: DataRepresentable {
    /// Convert an array to `Data`
    public var dataRepresentation: Data {
        return Array(self.keys).dataRepresentation + Array(self.values).dataRepresentation
    }
        
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromData data: Data, atOffset: inout Int) throws {
        let keys = try [Key](fromData: data, atOffset: &atOffset)
        let values = try [Value](fromData: data, atOffset: &atOffset)
        self.init(uniqueKeysWithValues: zip(keys,values))
    }    
}







