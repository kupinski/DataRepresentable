import XCTest
@testable import DataRepresentable
import simd

final class NumericDataTests: XCTestCase {
    func testScalars() throws {
        let intData = 1_234_567_890_123_456_789.dataRepresentation
        let dataToInt = Int(fromData: intData)
        XCTAssertEqual(1_234_567_890_123_456_789, dataToInt)

        let intMinData = Int.min.dataRepresentation
        let backToIntMin = Int(fromData: intMinData)
        XCTAssertEqual(Int.min, backToIntMin)

        let intMaxData = Int.max.dataRepresentation
        let backToIntMax = Int(fromData: intMaxData)
        XCTAssertEqual(Int.max, backToIntMax)
        
        let doubleData = 12.51231.dataRepresentation
        let dataToDouble = Double(fromData: doubleData)
        XCTAssertEqual(12.51231, dataToDouble)
    }
    
    func testArrays() throws {
        let intAData = [0, 1, 2, 3, 10000, -1000, 5123112].dataRepresentation
        let dataToIntA = [Int](fromData: intAData)
        XCTAssertEqual([0, 1, 2, 3, 10000, -1000, 5123112], dataToIntA)

        let doubleAData = [0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity].dataRepresentation
        let dataToDoubleA = [Double](fromData: doubleAData)
        XCTAssertEqual([0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity], dataToDoubleA)
        
        let floatAData = [Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]).dataRepresentation
        let dataToFloatA = [Float](fromData: floatAData)
        XCTAssertEqual([Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]), dataToFloatA)

        
        let int8Data = [Int8]([127, -127, 12, -12]).dataRepresentation
        let dataToInt8 = [Int8](fromData: int8Data)
        XCTAssertEqual([Int8]([127, -127, 12, -12]), dataToInt8)
    }
    
    func testSIMD() throws {
        do {
            let simdData = SIMD3<Double>(1,-100,312).dataRepresentation
            let simd = SIMD3<Double>(fromData: simdData)
            XCTAssertEqual(SIMD3<Double>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD3<Float>(1,-100,312).dataRepresentation
            let simd = SIMD3<Float>(fromData: simdData)
            XCTAssertEqual(SIMD3<Float>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD3<Int>(1,-100,312).dataRepresentation
            let simd = SIMD3<Int>(fromData: simdData)
            XCTAssertEqual(SIMD3<Int>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD2<Double>(1,-100).dataRepresentation
            let simd = SIMD2<Double>(fromData: simdData)
            XCTAssertEqual(SIMD2<Double>(1,-100), simd)
        }
        do {
            let simdData = SIMD2<Float>(1,-100).dataRepresentation
            let simd = SIMD2<Float>(fromData: simdData)
            XCTAssertEqual(SIMD2<Float>(1,-100), simd)
        }
        do {
            let simdData = SIMD2<Int>(1,-100).dataRepresentation
            let simd = SIMD2<Int>(fromData: simdData)
            XCTAssertEqual(SIMD2<Int>(1,-100), simd)
        }
        
    }
}
