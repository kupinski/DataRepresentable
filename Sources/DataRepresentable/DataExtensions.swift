//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

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
