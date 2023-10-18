/*
 * Copyright (c) 2023 University of Arizona [UofA], All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property of UofA. The intellectual
 * and technical concepts contained herein are proprietary to UofA and may be covered by U.S. and
 * Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly forbidden unless
 * prior written permission is obtained from UofA. Access to the source code contained herein is
 * hereby forbidden to anyone except current UofA employees, managers or contractors who have
 * executed Confidentiality and Non-disclosure agreements explicitly covering such access.
 *
 * The copyright notice above does not evidence any actual or intended publication or disclosure of
 * this source code, which includes information that is confidential and/or proprietary, and is a
 * trade secret, of  UofA.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE, OR
 * PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF
 * UofA IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE LAWS AND INTERNATIONAL TREATIES. THE
 * RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY
 * ANY RIGHTS TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL
 * ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 */


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
    
}
