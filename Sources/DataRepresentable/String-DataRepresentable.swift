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
    /// > Important:  We use null termination to find the end of strings in `Data`.  This is likely both unsafe and may fail in certain rare circumstances.
    ///
    /// - Parameter data: The data to read from.  The used portion of `data` is removed from the structure so that subsequent bytes can be read.
    public init?(fromData data: inout Data) {
        let subData = data.prefix(while: {(tst) in tst != Array("\n".utf8)[0]})
        let retString = String(data: subData, encoding: .utf8)
        if (retString == nil) {
            return nil
        } else {
            // get rid of carriage return if it is in there.
            let filteredString = retString!.filter{(char) in char != "\r"}
            data = data.advanced(by: subData.count + 1) // +1 to get past the null termination
            self = filteredString
        }
    }
}
