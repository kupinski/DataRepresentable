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



extension Dictionary: DataRepresentable where Key: DataRepresentable, Value: DataRepresentable {
    /// Convert an array to `Data`
    public var dataRepresentation: Data {
        return Array(self.keys).dataRepresentation + Array(self.values).dataRepresentation
    }
        
    /// Initialize from Data.  Assumes the entire array is made up of `Element`.
    public init(fromData data: Data, atOffset: inout Int) throws {
        let keys = try [Key](fromData: data, atOffset: &atOffset)
        let values = try [Value](fromData: data, atOffset: &atOffset)
        self.init(uniqueKeysWithValues: zip(keys,values))
    }    
}







