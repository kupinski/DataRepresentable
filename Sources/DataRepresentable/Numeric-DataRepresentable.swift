import Foundation


/// Make all Numerics conform to DataRepresentable
extension Numeric {
    /// Convert a numeric value to `Data`.
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }

    
    /// Initialze a single numeric value from `Data`
    /// - Parameter data: The data to convert into a numeric value.
    public init?(fromData data: Data, atOffset: inout Int) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        let value: Self = data.extractValue(atOffset: &atOffset)
        self = value
    }
    
    /// Initialze a single numeric value from `Data`
    /// - Parameter data: The data to convert into a numeric value.
    public init?(fromData data: Data) {
        if (data.count < MemoryLayout<Self>.stride) {
            return nil
        }
        let value: Self = data.extractValue()
        self = value
    }

    
}

// We must do this to all the Numeric types to ensure that they do follow DataRepresentable.  These types can also be represented as an `Array` that is `DataRepresentable`.
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





