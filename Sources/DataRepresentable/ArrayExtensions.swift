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

/// A protocol that restricts the types of variables that can be ``DataRepresentable`` in an `Array`.
///
/// Currently, simple arrays of basic types like `Int`, `Double`,  or `SIMD3<Float>` can be represented as `Data` using ``DataRepresentable``.  This contraint is largely due to the simple nature of the `Data` representation.  For example, with an array of an array of `Float`, there is no way of telling when a sub-array ends and the next array begins without a more complicated data structure.  Similarly, and Array of `String` is not supported since strings can have variable size and we would need to parse them one by one to extract the array of `String` values.
///
/// This protocol is currently empty and it is assumed that for whatever strucutre adheres to `ArrayToDataRepresentable` that `MemoryLayout< Type >.stride` is a fixed stride for any realization of that type.  This works for `Double`, etc.


/// If an array is one of `ArrayToDataRepresentable`, then the array itself is `DataRepresentable`
extension Array: DataRepresentable where Element: DataRepresentable {
    /// Convert an array to `Data`
    public var continuousData: Data {
        var count = self.count
        let data1 = Data(bytes: &count, count: MemoryLayout<Int>.stride)
        let data2 = Data(bytes: self, count: MemoryLayout<Element>.stride * self.count)
        return data1 + data2
    }
    
    public var dataRepresentation: Data {
        var count = self.count
        let data1 = Data(bytes: &count, count: MemoryLayout<Int>.stride)
        let data2 = self.reduce(Data()){(old, nw) in old + nw.dataRepresentation}
        return data1 + data2
    }

    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromData data: Data, atOffset: inout Int) throws {
        let count: Int = data.extractValue(atOffset: &atOffset)
        self = []
        self.reserveCapacity(count)
        for _ in 0..<count {
            try self.append(Element(fromData: data, atOffset: &atOffset))
        }
    }
    
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromContinuousData data: Data, atOffset: inout Int) throws {
        let count: Int = data.extractValue(atOffset: &atOffset)
        self = data.extractArray(count: count, atOffset: &atOffset)
    }
    
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromContinuousData data: Data) throws {
        var offset = 0
        try self.init(fromContinuousData: data, atOffset: &offset)
    }

}







