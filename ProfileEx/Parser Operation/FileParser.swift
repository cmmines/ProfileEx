//
//  FileParser.swift
//  QuadraticFitting
//
//  Created by Owen Hildreth on 11/30/21.
//

import Foundation


struct FileParser {
    // TODO: Remove parseSeparator
    var parseSeparator: ParseSeparator = .comma
    
    
    
    // private var lines: [String] = [""]
    
    let allowedNumberCharacters = CharacterSet(charactersIn: "0123456789,.-")
    
    
    
    // MARK: - Public Parse
    
    func parseURL(_ urlIn: URL, using parseDetails: ParseDetails) async throws -> XZData {
        let dataParseingTask = Task { () -> XZData in
            async let experimentalDetails = self.parseExperimentalDetails(urlIn, using: parseDetails)
            
            async let header = self.parseHeader(urlIn, using: parseDetails)
            
            async let data = self.parseData(urlIn, using: parseDetails)
            
            let xzData = try await XZData(experimentalDetails, xHeader: header.xDataHeader, zHeader: header.zDataHeader, withData: data)
            
            return xzData
        }
        
        // result will be either XZData or an Error
        let result = await dataParseingTask.result
        
        // Either get the data or Rethrow the error
        let data = try result.get()
        
        return data
    }
    
    
    

    
    
    // MARK: - Parse Experimental Details
    func parseExperimentalDetails(_ urlIn: URL, using parseDetails: ParseDetails) async throws -> String {
        // Create the Experimental Details first
        if parseDetails.hasExperimentalDetails {
            var lineNumber = 0
            var experimentalDetails = ""
            
            for try await nextLine in urlIn.lines {
                lineNumber += 1
                if lineNumber > parseDetails.experimentalDetails_endingLine {
                    // Exit the loop if the nextLine has passed the ending line
                    break
                }
                if lineNumber >= parseDetails.experimentalDetails_startingLine {
                    // If still below the starting line, append this string to the experimental details
                    experimentalDetails.append(contentsOf: (nextLine + "\n"))
                }
                
                
            }
            return experimentalDetails
        }// END Parsing Experimental Details
        
        return ""
    }
    
    
    // MARK: - Parse Header
    func parseHeader(_ urlIn: URL, using parseDetails: ParseDetails) async throws -> (xDataHeader: String, zDataHeader: String) {
        
        if parseDetails.hasHeader {
            var lineNumber = 0
            var xDataHeader: String = ""
            var zDataHeader: String = ""
            
            
            for try await nextLine in urlIn.lines {
                lineNumber += 1
                // Exit the loop if the nextLine has passed the ending line
                if lineNumber > parseDetails.header_endingLine {
                    break
                }
                // If still below the starting line, append this string to the headers
                if lineNumber >= parseDetails.header_startingLine {
                    // Get the header of each string
                    if let headerComponents = parseHeaderLine(nextLine, with: parseDetails.header_separator) {
                        if headerComponents.count >= 2 {
                            xDataHeader.append(contentsOf: headerComponents[0])
                            zDataHeader.append(contentsOf: headerComponents[1])
                        }
                    }
                    
                }
            }
            
            return (xDataHeader: xDataHeader, zDataHeader: zDataHeader)
        } // END: Parsing Header
        
        return (xDataHeader: "", zDataHeader: "")
    }
    
    
    func parseHeaderLine(_ lineIn: String, with separator: ParseSeparator) -> [String]? {
        let components = lineIn.components(separatedBy: separator.characterset)
        
        if components.count == 2 {
            return components
        }
        
        return nil
    }
    
    
    // MARK: - Parse Data
    func parseData(_ urlIn: URL, using parseDetails: ParseDetails) async throws -> [XZPoint] {
        var lineNumber = 0
        var xzPointData: [XZPoint] = []
        
        for try await nextLine in urlIn.lines {
            lineNumber += 1
            

            // Don't parse any data below the starting line
            if lineNumber < parseDetails.data_startingLine {
                continue
            }
            
            // No need to parse data from an empty line
            if nextLine.isEmpty {continue}
            
            
            // Get the data from the line
            if let nextXZPoint = parseDataLine(nextLine, with: parseDetails.data_separator) {
                xzPointData.append(nextXZPoint)
            }
            
        }
        
        return xzPointData
    }
    
    
    func parseDataLine(_ lineIn: String, with separator: ParseSeparator) -> XZPoint? {
        let columnData = lineIn.components(separatedBy: separator.characterset)
        
        // Make sure we still have the correct number of columns
        if columnData.count < 2 {
            return nil
        }
        
        // Get the Double Values from the parsed line
        guard let xData = filteredDouble(columnData[0]) else {return nil}
        guard let zData = filteredDouble(columnData[1]) else {return nil}
        
        // Use the Data to create an XZPoint and return it
        return XZPoint(x: xData, z: zData)
    }
    
    
    
    func filteredDouble(_ stringIn: String) -> Double? {
        // Filter the string to remove anything that wouldn't be considered a number
        let filteredString = String(stringIn.unicodeScalars.filter(allowedNumberCharacters.contains))
        
        return Double(filteredString)
    }
    

}
