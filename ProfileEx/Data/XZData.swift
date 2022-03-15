//
//  XZData.swift
//  QuadraticFitting
//
//  Created by Owen Hildreth on 12/2/21.
//

import Foundation


struct XZData {
    var experimentalDetails: String = ""
    var xDataHeader: String = "X Data [µm]"
    var zDataHeader: String = "Z Data [Å]"
    var data: [XZPoint] = []
    
    var xData:[Double] {
        get {return data.map({ $0.x})}
    }
    var zData:[Double] {
        get {return data.map({ $0.z})}
    }
    
    init(_ experimentalDetailsIn: String, xHeader: String, zHeader: String, withData dataIn: [XZPoint]) {
        self.experimentalDetails = experimentalDetailsIn
        self.xDataHeader = xHeader
        self.zDataHeader = zHeader
        self.data = dataIn
    }
    
    
    init() {
        self.init(withPoints: [])
    }
    
    init(withPoints dataIn: [XZPoint])  {
        self.init("", xHeader: "", zHeader: "", withData: dataIn)
    }
    
    init(xData xDataIn: [Double], zData zDataIn: [Double]) throws {
        if xDataIn.count != zDataIn.count {
            print("Error with Data")
            print("xFirst = \(String(describing: xDataIn.first))")
            print("zFirst = \(String(describing: zDataIn.first))")
            throw XZDataError.xzDataSizeDoesntMatch
        }
        
        var localData:[XZPoint] = []
        localData.reserveCapacity(xDataIn.count)
        
        for index in 0..<xDataIn.count {
            let nextPoint = XZPoint(x: xDataIn[index], z: zDataIn[index])
            localData.append(nextPoint)
        }
        
        self.init(withPoints: localData)
    }
}


/**
 class XZData: ObservableObject {
     
     
     @Published var experimentalDetails: String = ""
     @Published var xDataHeader: String = "X Data [µm]"
     @Published var zDataHeader: String = "Y Data [Å]"
     @Published var data: [XZPoint] = []
     
     var xData:[Double] {
         get {return data.map({ $0.x})}
     }
     var zData:[Double] {
         get {return data.map({ $0.z})}
     }
     
     init(_ experimentalDetailsIn: String, xHeader: String, zHeader: String, withData dataIn: [XZPoint]) {
         self.experimentalDetails = experimentalDetailsIn
         self.xDataHeader = xHeader
         self.zDataHeader = zHeader
         self.data = dataIn
     }
     
     convenience init() {
         self.init("", xHeader: "X Data [µm]", zHeader: "Y Data [Å]", withData: [])
     }
     
     
     convenience init(withPoints dataIn: [XZPoint])  {
         self.init("", xHeader: "", zHeader: "", withData: dataIn)
     }
     
     convenience init(xData xDataIn: [Double], zData zDataIn: [Double]) throws {
         if xDataIn.count != zDataIn.count {
             print("Error with Data")
             print("xFirst = \(String(describing: xDataIn.first))")
             print("zFirst = \(String(describing: zDataIn.first))")
             throw XZDataError.xzDataSizeDoesntMatch
         }
         
         var localData:[XZPoint] = []
         localData.reserveCapacity(xDataIn.count)
         
         for index in 0..<xDataIn.count {
             let nextPoint = XZPoint(x: xDataIn[index], z: zDataIn[index])
             localData.append(nextPoint)
         }
         
         self.init(withPoints: localData)
     }
 }
 */


// MARK: - Custom Errors
extension XZData {
    enum XZDataError: Error {
        case xzDataSizeDoesntMatch
    }
}

// MARK: - Protocol: Double Column Data
extension XZData: DoubleColumnData {
    var firstColumn: [Double] {
        get{return xData}
    }
    
    var secondColumn: [Double] {
        get{return zData}
    }
}


protocol DoubleColumnData {
    associatedtype Value
    var firstColumn: [Value] {get}
    var secondColumn: [Value] {get}
}
