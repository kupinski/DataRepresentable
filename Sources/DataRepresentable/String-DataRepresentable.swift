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
        guard let ret = self.dataRepresentation(with: .utf8) else {
            fatalError("Could not parse string \(self)")
        }
        return(ret)
    }
    
    public func dataRepresentation(with encoding: String.Encoding) -> Data? {
        if let data3 = self.data(using: encoding) {
            var count = data3.count
            let data1 = Data(bytes: &count, count: MemoryLayout<Int>.stride)
            var enc = encoding.rawValue
            let data2 = Data(bytes: &enc, count: MemoryLayout<UInt>.stride)
            
            return data1 + data2 + data3
        } else {
            return nil
        }
    }
    
    /// Process a string from a data stream
    ///
    /// - Parameter data: The data to read from.  The used portion of `data` is removed from the structure so that subsequent bytes can be read.
    public init(fromData data: Data, atOffset: inout Int) throws {
        let length:Int = data.extractValue(atOffset: &atOffset)
        let encoding = String.Encoding(rawValue: data.extractValue(atOffset: &atOffset))
        let subData = data.subdata(in: atOffset..<(atOffset + length))
        atOffset += length
        if let ret = String(data: subData, encoding: encoding) {
            self = ret
        } else {
            throw DataRepresentableError.invalidString
        }
    }
    
    /// Process a string from a data stream
    ///
    /// - Parameter data: The data to read from.  The used portion of `data` is removed from the structure so that subsequent bytes can be read.
    public init(fromData data: Data) throws {
        let twoInts: [UInt] = data.extractArray(count: 2)
        let count = Int(twoInts[0])
        let enc = String.Encoding(rawValue: twoInts[1])
        
        let subData = data.subdata(in: (MemoryLayout<UInt>.stride * 2)..<(count + MemoryLayout<UInt>.stride * 2))
        if let ret = String(data: subData, encoding: enc) {
            self = ret
        } else {
            throw DataRepresentableError.invalidString
        }
    }

}
