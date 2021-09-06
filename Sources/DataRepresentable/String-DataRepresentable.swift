//
//  File.swift
//  File
//
//  Created by Matthew Kupinski on 9/2/21.
//

import Foundation

extension String: DataRepresentable {
    public var dataRepresentation: Data {
        let z = self.cString(using: .utf8)!
        return z.dataRepresentation
    }
    
    public init(fromData data: inout Data) {
        let subData = data.prefix(while: {(tst) in tst != 0})
        self.init(data: subData, encoding: .utf8)!
        data = data.advanced(by: subData.count + 1)
    }
}
