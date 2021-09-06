import Foundation


/// Make all Numerics conform to DataRepresentable
extension Numeric {
    /// Convert a numeric value to `Data`.
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }

    
    /// Initialze a single numeric value from `Data`
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

// We must do this to all the Numeric types to ensure that they do follow DataRepresentable
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





