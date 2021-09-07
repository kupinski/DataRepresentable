import XCTest
@testable import DataRepresentable
import simd

final class NumericDataTests: XCTestCase {
    func testScalars() throws {
        var intData = 1_234_567_890_123_456_789.dataRepresentation
        let dataToInt = Int(fromData: &intData)
        XCTAssertEqual(1_234_567_890_123_456_789, dataToInt)

        var intMinData = Int.min.dataRepresentation
        let backToIntMin = Int(fromData: &intMinData)
        XCTAssertEqual(Int.min, backToIntMin)

        var intMaxData = Int.max.dataRepresentation
        let backToIntMax = Int(fromData: &intMaxData)
        XCTAssertEqual(Int.max, backToIntMax)
        
        var doubleData = 12.51231.dataRepresentation
        let dataToDouble = Double(fromData: &doubleData)
        XCTAssertEqual(12.51231, dataToDouble)
    }
    
    func testArrays() throws {
        var intAData = [0, 1, 2, 3, 10000, -1000, 5123112].dataRepresentation
        let dataToIntA = [Int](fromData: &intAData)
        XCTAssertEqual([0, 1, 2, 3, 10000, -1000, 5123112], dataToIntA)

        var doubleAData = [0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity].dataRepresentation
        let dataToDoubleA = [Double](fromData: &doubleAData)
        XCTAssertEqual([0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity], dataToDoubleA)
        
        var floatAData = [Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]).dataRepresentation
        let dataToFloatA = [Float](fromData: &floatAData)
        XCTAssertEqual([Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]), dataToFloatA)
        
        var int8Data = [Int8]([127, -127, 12, -12]).dataRepresentation
        let dataToInt8 = [Int8](fromData: &int8Data)
        XCTAssertEqual([Int8]([127, -127, 12, -12]), dataToInt8)
        
        var floatAData1 = [Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]).dataRepresentation
        let dataToFloatA1 = [Float](fromData: &floatAData1, count: 2)
        let dataToFloatA2 = [Float](fromData: &floatAData1)
        XCTAssertEqual([Float]([0.13, 12312541.23]), dataToFloatA1)
        XCTAssertEqual([Float]([1251e-10, 0.0523, Float.infinity]), dataToFloatA2)

    }
    
    func testSIMD() throws {
        do {
            var simdData = SIMD3<Double>(1,-100,312).dataRepresentation
            let simd = SIMD3<Double>(fromData: &simdData)
            XCTAssertEqual(SIMD3<Double>(1,-100,312), simd)
        }
        do {
            var simdData = SIMD3<Float>(1,-100,312).dataRepresentation
            let simd = SIMD3<Float>(fromData: &simdData)
            XCTAssertEqual(SIMD3<Float>(1,-100,312), simd)
        }
        do {
            var simdData = SIMD3<Int>(1,-100,312).dataRepresentation
            let simd = SIMD3<Int>(fromData: &simdData)
            XCTAssertEqual(SIMD3<Int>(1,-100,312), simd)
        }
        do {
            var simdData = SIMD2<Double>(1,-100).dataRepresentation
            let simd = SIMD2<Double>(fromData: &simdData)
            XCTAssertEqual(SIMD2<Double>(1,-100), simd)
        }
        do {
            var simdData = SIMD2<Float>(1,-100).dataRepresentation
            let simd = SIMD2<Float>(fromData: &simdData)
            XCTAssertEqual(SIMD2<Float>(1,-100), simd)
        }
        do {
            var simdData = SIMD2<Int>(1,-100).dataRepresentation
            let simd = SIMD2<Int>(fromData: &simdData)
            XCTAssertEqual(SIMD2<Int>(1,-100), simd)
        }
        do {
            var simdData = SIMD2<Int8>(1,-100).dataRepresentation
            let simd = SIMD2<Int8>(fromData: &simdData)
            XCTAssertEqual(SIMD2<Int8>(1,-100), simd)
        }

    }
    
    
    
    func testStrings() throws {
        do { // Convert a string to Data and back
            let string = "Happy to see you: µ, π, 🧐"
            var data = string.dataRepresentation
            let string2 = String(fromData: &data)
            XCTAssertEqual(string, string2)
        }
        do { // Convert two strings to Data and back.  Check null termination.
            let string1 = "Happy to see you: µ, π, 🧐"
            let string2 = "What's happening?"
            var data = string1.dataRepresentation + string2.dataRepresentation
            let string3 = String(fromData: &data)
            let string4 = String(fromData: &data)
            XCTAssertEqual(string1, string3)
            XCTAssertEqual(string2, string4)
        }
        do { // Convert a string and a double to Data and back.
            let string1 = "Happy to see you: µ, π, 🧐"
            let val1 = 123.415
            var data = string1.dataRepresentation + val1.dataRepresentation
            let string2 =  String(fromData: &data)
            let val2 =  Double(fromData: &data)
            XCTAssertEqual(string1, string2)
            XCTAssertEqual(val1,val2)

        }
        
    }
    
}
