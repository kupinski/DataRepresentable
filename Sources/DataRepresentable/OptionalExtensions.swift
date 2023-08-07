//
//  File.swift
//  
//
//  Created by Matthew Kupinski on 6/5/23.
//

import Foundation


extension Optional where Wrapped: DataRepresentable {
    public var dataRepresentation: Data {
        if let z = self {
            return(true.dataRepresentation + z.dataRepresentation)
        } else {
            return(false.dataRepresentation)
        }
    }

    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromData data: Data, atOffset: inout Int) throws {
        let valueExists = try Bool(fromData: data, atOffset: &atOffset)
        if (valueExists) {
            self = try Wrapped(fromData: data, atOffset: &atOffset)
        } else {
            self = nil
        }
    }
}
