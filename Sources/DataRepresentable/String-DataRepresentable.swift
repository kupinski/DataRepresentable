//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/2/21.
//

import Foundation

extension String: DataRepresentable {
    /// The data representation of a string is done using null terminated UTF 8 strings.
    ///
    /// This is generally thought of as not safe.
    public var dataRepresentation: Data {
        let z = self.cString(using: .utf8)!
        return z.dataRepresentation
    }
    
    /// Process a string from a data stream
    ///
    /// This is generally thought of as not safe.
    public init(fromData data: inout Data) {
        let subData = data.prefix(while: {(tst) in tst != 0})
        self.init(data: subData, encoding: .utf8)!
        data = data.advanced(by: subData.count + 1) // +1 to get past the null termination
    }
}
