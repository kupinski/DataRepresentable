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
import Compression
    
extension Data {
    
    public func compress(using: NSData.CompressionAlgorithm = .lzfse) throws -> Data {
        try (self as NSData).compressed(using: using) as Data
    }
    
    public func unCompress(using: NSData.CompressionAlgorithm = .lzfse) throws -> Data {
        try(self as NSData).decompressed(using: using) as Data
    }
    


    public func extractArray<T>(count: Int, atOffset: inout Int) -> [T] {
        let subData = self.subdata(in: atOffset..<(atOffset + MemoryLayout<T>.stride * count))
        let ret = subData.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0.bindMemory(to: T.self).baseAddress, count: count))
        }
        atOffset += MemoryLayout<T>.stride * Int(count)
        return ret
    }
    
    public func extractArray<T>(count: Int) -> [T] {
        let subData = self.subdata(in: 0..<MemoryLayout<T>.stride * count)
        let ret = subData.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0.bindMemory(to: T.self).baseAddress, count: count))
        }
        return ret
    }

    public func extractValue<T>(atOffset: inout Int) -> T {
        let subData = self.subdata(in: atOffset..<(atOffset + MemoryLayout<T>.stride))
        let ret = subData.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0.bindMemory(to: T.self).baseAddress, count: 1))
        }
        atOffset += MemoryLayout<T>.stride
        return ret.first!
    }
    
    public func extractValue<T>() -> T {
        let subData = self.subdata(in: 0..<MemoryLayout<T>.stride)
        let ret = subData.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0.bindMemory(to: T.self).baseAddress, count: 1))
        }
        return ret.first!
    }
    
    public func extractSubString(atOffset: inout Int) -> String? {
        let length:Int = self.extractValue(atOffset: &atOffset)
        let encoding = String.Encoding(rawValue: self.extractValue(atOffset: &atOffset))
        let subData = self.subdata(in: atOffset..<(atOffset + length))
        atOffset += length
        return String(data: subData, encoding: encoding)
    }

    
}
