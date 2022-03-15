//
//  ParseDetails.swift
//  SimpleProfile
//
//  Created by Owen Hildreth on 12/29/21.
//

struct ParseDetails {
    var hasExperimentalDetails = false
    var hasHeader = false
    
    var data_separator: ParseSeparator = .comma
    var header_separator: ParseSeparator = .comma
    
    // This values have coupled restrictions.  They must be larger than 0 and each starting line must be larger than the last ending line.  To do this, the public facing variables will use getters and setters on private variables.
    var experimentalDetails_startingLine: Int {get {_experimentalDetails_startingLine}
        set{
            let setValue = setLineValue(lowestValue: 1, proposedValue: newValue)
            _experimentalDetails_startingLine = setValue
            if setValue > experimentalDetails_endingLine { experimentalDetails_endingLine = setValue }
        }
    }
    var experimentalDetails_endingLine: Int {get {_experimentalDetails_endingLine}
        set {
            let setValue = setLineValue(lowestValue: _experimentalDetails_startingLine, proposedValue: newValue)
            _experimentalDetails_endingLine = setValue
            if setValue > header_startingLine { header_startingLine = setValue }
        }
    }
    
    var header_startingLine: Int {get {_header_startingLine}
        set {
            let setValue = setLineValue(lowestValue: _experimentalDetails_endingLine, proposedValue: newValue)
            _header_startingLine = setValue
            if setValue > header_endingLine { header_endingLine = setValue }
        }
    }
    var header_endingLine: Int {get {_header_endingLine}
        set {
            let setValue = setLineValue(lowestValue: _header_startingLine, proposedValue: newValue)
            _header_endingLine = setValue
            if setValue > data_startingLine { data_startingLine = setValue }
        }
    }
    var data_startingLine: Int {get {_data_startingLine}
        set {
            let setValue = setLineValue(lowestValue: _header_endingLine, proposedValue: newValue)
            _data_startingLine = setValue
        }
    }
    
    private var _experimentalDetails_startingLine = 1
    private var _experimentalDetails_endingLine = 1
    private var _header_startingLine = 1
    private var _header_endingLine = 1
    private var _data_startingLine = 1
    
    private func setLineValue(lowestValue: Int, proposedValue: Int) -> Int {
        if (proposedValue < 0) {return 0}
        else if (proposedValue < lowestValue) {return lowestValue}
        else {return proposedValue}
    }
    
    
    /**
     var hasExperimentalDetals: Bool
     var experimentalDetails_startingLine: Int
     var experimentalDetails_endingLine: Int
     
     
     var hasHeader: Bool
     var header_separator: ParseSeparator
     var header_startingLine: Int
     var header_endingLine: Int
     
     
     var data_startingLine: Int
     var data_sepatator: ParseSeparator
     
     
     init(_ hasExperimentalDetalsIn: Bool,
          _ experimentalDetails_startingLineIn: Int,
          _ experimentalDetails_endingLineIn: Int,
          _ hasHeaderIn: Bool,
          _ header_separatorIn: ParseSeparator,
          _ header_startingLineIn: Int,
          _ header_endingLineIn: Int,
          _ data_startingLineIn: Int,
          _ data_sepatatorIn: ParseSeparator) {
         self.hasExperimentalDetals = hasExperimentalDetalsIn
         self.experimentalDetails_startingLine = experimentalDetails_startingLineIn
         self.experimentalDetails_endingLine = experimentalDetails_endingLineIn
         
         self.hasHeader = hasHeaderIn
         self.header_separator = header_separatorIn
         self.header_startingLine = header_startingLineIn
         self.header_endingLine = header_endingLineIn
         
         self.data_startingLine = data_startingLineIn
         self.data_sepatator = data_sepatatorIn
     }
     
     */
    
}
