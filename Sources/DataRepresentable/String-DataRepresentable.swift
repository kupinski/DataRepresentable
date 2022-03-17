//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/2/21.
//

import Foundation

extension String: DataRepresentable {
    /// The data representation of a string is done using  UTF 8 strings.
    ///
    /// Note that the \n for a terminated string must be in the string itself.  This routine does not add it!
    ///
    /// No error checking on the conversion of the string to utf8.  So if the user has an emoji in there, this will fail..
    public var dataRepresentation: Data {
        return self.data(using: .utf8)!
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
