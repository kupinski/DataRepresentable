import Foundation


/// Make all Numerics conform to DataRepresentable
extension Numeric {
    /// Convert a numeric value to `Data`.
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }

    
    /// Initialze a single numeric value from `Data`
    /// - Parameter data: The data to convert into a numeric value.  The used portion of `data` is removed from the structure.
    public init?(fromData data: inout Data) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        var value: Self = .zero
        let numBytes = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        data = data.advanced(by: numBytes)

        self = value
    }
    
}

// We must do this to all the Numeric types to ensure that they do follow DataRepresentable.  These types can also be represented as an `Array` that is `DataRepresentable`.
extension Float: DataRepresentable, ArrayToDataRepresentable {}
extension Double: DataRepresentable, ArrayToDataRepresentable {}
extension CGFloat: DataRepresentable, ArrayToDataRepresentable {}

extension Int: DataRepresentable, ArrayToDataRepresentable {}
extension Int64: DataRepresentable, ArrayToDataRepresentable {}
extension Int32: DataRepresentable, ArrayToDataRepresentable {}
extension Int16: DataRepresentable, ArrayToDataRepresentable {}
extension Int8: DataRepresentable, ArrayToDataRepresentable {}

extension UInt: DataRepresentable, ArrayToDataRepresentable {}
extension UInt64: DataRepresentable, ArrayToDataRepresentable {}
extension UInt32: DataRepresentable, ArrayToDataRepresentable {}
extension UInt16: DataRepresentable, ArrayToDataRepresentable {}
extension UInt8: DataRepresentable, ArrayToDataRepresentable {}





