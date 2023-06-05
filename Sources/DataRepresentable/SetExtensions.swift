//
//  File.swift
//  
//
//  Created by Matthew Kupinski on 6/5/23.
//

import Foundation

extension Set where Element: DataRepresentable {
    public var dataRepresentation: Data {
        Array(self).dataRepresentation
    }
    
    public init(fromData data: Data, atOffset: inout Int) throws {
        self = try Set(Array<Element>(fromData: data, atOffset: &atOffset))
    }
}
