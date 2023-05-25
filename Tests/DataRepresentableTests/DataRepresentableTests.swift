import XCTest
@testable import DataRepresentable
import simd

final class NumericDataTests: XCTestCase {
    func testScalars() throws {
        let intData = 1_234_567_890_123_456_789.dataRepresentation
        let dataToInt = try Int(fromData: intData)
        XCTAssertEqual(1_234_567_890_123_456_789, dataToInt)

        let intMinData = Int.min.dataRepresentation
        let backToIntMin = try Int(fromData: intMinData)
        XCTAssertEqual(Int.min, backToIntMin)

        let intMaxData = Int.max.dataRepresentation
        let backToIntMax = try Int(fromData: intMaxData)
        XCTAssertEqual(Int.max, backToIntMax)
        
        let doubleData = 12.51231.dataRepresentation
        let dataToDouble = try Double(fromData: doubleData)
        XCTAssertEqual(12.51231, dataToDouble)
    }
    
    func testArrays() throws {
        let intAData = [0, 1, 2, 3, 10000, -1000, 5123112].dataRepresentation
        let dataToIntA = try [Int](fromData: intAData)
        XCTAssertEqual([0, 1, 2, 3, 10000, -1000, 5123112], dataToIntA)

        let doubleAData = [0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity].dataRepresentation
        let dataToDoubleA = try [Double](fromData: doubleAData)
        XCTAssertEqual([0.13, 12312541.23, 1251e-10, 0.0523, Double.infinity], dataToDoubleA)
        
        let floatAData = [Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]).dataRepresentation
        let dataToFloatA = try [Float](fromData: floatAData)
        XCTAssertEqual([Float]([0.13, 12312541.23, 1251e-10, 0.0523, Float.infinity]), dataToFloatA)
        
        let int8Data = [Int8]([127, -127, 12, -12]).dataRepresentation
        let dataToInt8 = try [Int8](fromData: int8Data)
        XCTAssertEqual([Int8]([127, -127, 12, -12]), dataToInt8)
    }
    
    func testSIMD() throws {
        do {
            let simdData = SIMD3<Double>(1,-100,312).dataRepresentation
            let simd = try SIMD3<Double>(fromData: simdData)
            XCTAssertEqual(SIMD3<Double>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD3<Float>(1,-100,312).dataRepresentation
            let simd = try SIMD3<Float>(fromData: simdData)
            XCTAssertEqual(SIMD3<Float>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD3<Int>(1,-100,312).dataRepresentation
            let simd = try SIMD3<Int>(fromData: simdData)
            XCTAssertEqual(SIMD3<Int>(1,-100,312), simd)
        }
        do {
            let simdData = SIMD2<Double>(1,-100).dataRepresentation
            let simd = try SIMD2<Double>(fromData: simdData)
            XCTAssertEqual(SIMD2<Double>(1,-100), simd)
        }
        do {
            let simdData = SIMD2<Float>(1,-100).dataRepresentation
            let simd = try SIMD2<Float>(fromData: simdData)
            XCTAssertEqual(SIMD2<Float>(1,-100), simd)
        }
        do {
            let simdData = SIMD2<Int>(1,-100).dataRepresentation
            let simd = try SIMD2<Int>(fromData: simdData)
            XCTAssertEqual(SIMD2<Int>(1,-100), simd)
        }
        do {
            let simdData = SIMD2<Int8>(1,-100).dataRepresentation
            let simd = try SIMD2<Int8>(fromData: simdData)
            XCTAssertEqual(SIMD2<Int8>(1,-100), simd)
        }

    }
    
    
    
    func testStrings() throws {
        let string1 = "Happy to see you: µ, π, 🧐"
        let string2 =
"""
 What's happening Now that this is going on.
        I don't know if this will work.
        Happy to see you: µ, π, 🧐
"""

        do { // Convert a string to Data and back
            let stringData = string1.dataRepresentation
            let str = try String(fromData: stringData)
            XCTAssertEqual(str,string1)
        }
        do { // Convert a string to Data and back
            let stringData = string2.dataRepresentation
            let str = try String(fromData: stringData)
            XCTAssertEqual(str,string2)
        }
    }
    
    func testStructures() throws {
        print(MemoryLayout<String>.stride)
        
        let value1 = Float(12.1).dataRepresentation
        let value2 = UInt8(32).dataRepresentation
        let array1 = [Double]([3.141, 2.2, exp(-2)]).dataRepresentation
        let array2 = [UInt8]([1, 2, 3, 4, 3, 2, 1]).dataRepresentation
        let array3 = [SIMD3<Float>]([SIMD3<Float>(1,2,3), SIMD3<Float>(4,5,6)]).dataRepresentation
        let string1 = "Happy to see you: µ, π, 🧐".dataRepresentation
        let string2 =
"""
 What's happening Now that this is going on.
        I don't know if this will work.
        Happy to see you: µ, π, 🧐
""".dataRepresentation

        let totalData = string1 + value1 + array1 + string2 + array2 + value2 + array3
        
        var offset = 0
        let dstring1 = try String(fromData: totalData, atOffset: &offset)
        let dvalue1 = try Float(fromData: totalData, atOffset: &offset)
        let darray1 = try [Double](fromData: totalData, atOffset: &offset)
        let dstring2 = try String(fromData: totalData, atOffset: &offset)
        let darray2 = try [UInt8](fromData: totalData, atOffset: &offset)
        let dvalue2 = try UInt8(fromData: totalData, atOffset: &offset)
        let darray3 = try [SIMD3<Float>](fromData: totalData, atOffset: &offset)
        
        XCTAssertEqual(dvalue1, Float(12.1))
        XCTAssertEqual(dvalue2, UInt8(32))
        
        XCTAssertEqual(darray1, [Double]([3.141, 2.2, exp(-2)]))
        XCTAssertEqual(darray2, [UInt8]([1, 2, 3, 4, 3, 2, 1]))
        
        XCTAssertEqual(dstring1, "Happy to see you: µ, π, 🧐")
        XCTAssertEqual(dstring2,
"""
 What's happening Now that this is going on.
        I don't know if this will work.
        Happy to see you: µ, π, 🧐
""")

        XCTAssertEqual(darray3, [SIMD3<Float>]([SIMD3<Float>(1,2,3), SIMD3<Float>(4,5,6)]))
        
    }
    
    func testArrayOfStrings() throws {
        var strings = ["Hello", "Goodbye", "😀","This is a test of the emergency broadcast system.  This is only a test"]
        
        let data = strings.dataRepresentation
        print(MemoryLayout<String>.stride)
        
        let newStrings = try [String](fromData: data)
        
        strings = ["blah","blah","blah","blah"]
        print(strings)
        print(newStrings)
    }
    
    func testFileCompression() throws {
        let rawData = Array(repeating: 1.0, count: 1_000_000)
        let fileName = "/tmp/\(UUID().uuidString).rawData"
        let url = URL(filePath: fileName)
        print("Writing file")
        try rawData.write(toURL: url)
        print("Reading file")
        let newData = try [Double](fromURL: url)
        XCTAssertEqual(newData, rawData)
        
        let attr = try FileManager.default.attributesOfItem(atPath: fileName)
        let size = attr[.size] as! Int

        print("Compression = \((1.0 - (Double(size) / Double(rawData.count))) * 100.0) %")

    }

    
    
}
