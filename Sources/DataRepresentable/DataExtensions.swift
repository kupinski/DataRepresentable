//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/1/21.
//

import Foundation

extension Data {
    mutating func process<C: DataRepresentable>() -> C {
        let val = self.withUnsafeBytes {$0.load(as: C.self)}
        self = self.advanced(by: MemoryLayout<C>.stride)
        return(val)
    }
    
    mutating func process<C>(count: Int) -> [C] {
        let arr = Array<C>(unsafeUninitializedCapacity: count,
                     initializingWith: {(buf, initCount) in
            _ = self.copyBytes(to: buf)
            initCount = count
        })

        self = self.advanced(by: MemoryLayout<C>.stride * count)
        return(arr)
    }

}
