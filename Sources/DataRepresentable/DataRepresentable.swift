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
import simd

public enum DataRepresentableError: Error {
    case notEnoughBytes
    case classRepresentationNotSpecified
    case invalidString
    case unexpected(case: Int)
}

extension DataRepresentableError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notEnoughBytes: return("Data stream doesn't contain sufficient length to read in data")
        case .classRepresentationNotSpecified: return("Class types must override dataRepresentation and initializers.  Defaults will not work.")
        case .invalidString: return("The Data has an invalid string representation.")
        case .unexpected(_): return("An unexpected error occured")
        }
    }
}


/// When an object conforms to `DataRepresentable`, then this individual type as well as arrays of this type can be converted to `Data`
///
/// There is no checking that the representation in `Data` form is compatible across machines.  Endianness issues must be handled by the user when appropriate.
///
///  Anything that is `DataRepresentable` always uses `MemoryLayout<T>.stride` number of bytes.  This helps with compatibility with arrays of `DataRepresentable`.
public protocol DataRepresentable {
    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  The passed `atOffset` is marked as `inout` because the offset will be incremented based on the  number of bytes read.
    init(fromData data: Data, atOffset: inout Int) throws

    /// Create a `DataRepresentable` from `Data`.   Returns `nil` if the conversion fails.  Does not keeps track of the offset.
    init(fromData data: Data) throws

    /// Convert the object to `Data`
    var dataRepresentation: Data { get }
}


extension DataRepresentable {
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }
    
    public init(fromData data: Data, atOffset: inout Int) throws {
        if ((data.count - atOffset) < MemoryLayout<Self>.stride) {
            throw DataRepresentableError.notEnoughBytes
        }
        let value: Self = data.extractValue(atOffset: &atOffset)
        self = value
        if (type(of: self) is AnyClass) {
            throw DataRepresentableError.classRepresentationNotSpecified
        }
    }
    
    public init(fromData data: Data) throws {
        var offset = 0
        try self.init(fromData: data, atOffset: &offset)
    }
    
}


extension Float: DataRepresentable {}
extension Double: DataRepresentable {}
extension CGFloat: DataRepresentable {}

extension Int: DataRepresentable {}
extension Int64: DataRepresentable {}
extension Int32: DataRepresentable {}
extension Int16: DataRepresentable {}
extension Int8: DataRepresentable {}

extension UInt: DataRepresentable {}
extension UInt64: DataRepresentable {}
extension UInt32: DataRepresentable {}
extension UInt16: DataRepresentable {}
extension UInt8: DataRepresentable {}

extension SIMD2 : DataRepresentable {}
extension SIMD3 : DataRepresentable {}
extension SIMD4 : DataRepresentable {}
extension SIMD8 : DataRepresentable {}
extension SIMD16 : DataRepresentable {}
extension SIMD32 : DataRepresentable {}
extension SIMD64 : DataRepresentable {}

extension simd_float4x4: DataRepresentable {}
extension simd_bool: DataRepresentable {}

