import Foundation


/// Make all Numerics conform to DataRepresentable
extension Numeric {
    /// Convert a numeric value to `Data`.
    public var dataRepresentation: Data {
        var source = self
        return .init(bytes: &source, count: MemoryLayout<Self>.stride)
    }

    
    /// Initialze a single numeric value from `Data`
    public init(fromData data: Data) {
        var value: Self = .zero
        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        assert(size == MemoryLayout.size(ofValue: value))
        self = value
    }
    
    /// The dataStride for the `DataRepresentable`.
    static public var dataStride: Int {
        return MemoryLayout< Self >.stride
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





