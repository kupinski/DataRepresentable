//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation

extension Data {
    
    /// Extract an entry of type `C` from the front of at `Data` stream and then remove those bytes from `Data`
    ///
    /// Required a mutable `Data`.
    /// - Returns: The value of type `C` which must be ``DataRepresentable``
    public mutating func process<C: DataRepresentable>() -> C {
        let val = self.withUnsafeBytes {$0.load(as: C.self)}
        self = self.advanced(by: MemoryLayout<C>.stride)
        return(val)
    }
    
    /// Extract `count` elements of type `C` from a `Data` stream and then remove all of those bytes from `Data.`
    ///
    /// If `Data` doesn't have enough bytes to contain `count` entries of type `C`, then a smaller array will be returned.  There is no errors or warnings of this.  Users must check the size of the return array againts `count`.
    /// - Returns: The array of type `C`.
    public mutating func process<C>(count: Int) -> [C] {
        let arr = Array<C>(unsafeUninitializedCapacity: count,
                     initializingWith: {(buf, initCount) in
            let bytes = self.copyBytes(to: buf)
            initCount = bytes / MemoryLayout<C>.stride
        })

        // Don't advance by count in case there wasn't enough data to extract
        self = self.advanced(by: MemoryLayout<C>.stride * arr.count)
        return(arr)
    }

}
