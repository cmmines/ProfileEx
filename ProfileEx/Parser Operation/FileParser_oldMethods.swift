//
//  FileParser_oldMethods.swift
//  SimpleProfile
//
//  Created by Owen Hildreth on 12/29/21.
//

import Foundation


extension FileParser {
    
    // MARK: - Version 2
    func parseURL_v2(_ urlIn: URL, using parseDetails: ParseDetails) async throws -> XZData {
        
        var localData = XZData()

        // This routine assumes that Experimental Details and Header are short enough to not impact parsing time
        
        
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
            localData.experimentalDetails = experimentalDetails
        }// END Parsing Experimental Details
        

        // Create the Header Second
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
            
            localData.xDataHeader = xDataHeader
            localData.zDataHeader = zDataHeader
        } // END: Parsing Header
        
        
        // Parse the Data
        var lineNumber = 0
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
                localData.data.append(nextXZPoint)
            }
            
        }
        
        
        return localData
    }
    
    
    // MARK: - Version 1
    
    func parseURL(_ urlIn: URL) throws -> XZData {
        guard let content = getContentFrom(urlIn) else {
            throw ParseError.noStringInURL
        }
        
        let data = parseString(content, withSeparators: self.parseSeparator.characterset)
        
        if data.count < 2 {
            throw ParseError.notEnoughColumns
        }
        
        return try XZData(xData: data[0], zData: data[1])
    }
    
    
    func getContentFrom(_ url: URL) -> String? {
        let filePath = url.path
        
        guard let contentData = FileManager.default.contents(atPath: filePath) else {return nil}
        
        let contentString = String(data: contentData, encoding: .ascii)
        
        return contentString
    }
    
    
    
    
    
    func parseString(_ contentString: String, withSeparators separatorsIn: CharacterSet) -> [[Double]] {
        
        // Create a local data array to store the parsed data.
        var localData: [[Double]] = []
        
        // get array of lines
        let lines = contentString.components(separatedBy: .newlines).filter({!$0.isEmpty})
        
        
        // figure out how many columns of data there are
        // get the first line
        guard let firstLine = lines.first else {return localData}
        // components(separatedBy:) returns an array of strings separated by the specified character set
        // use .count on this array to get the number of columns
        let numberOfColumns = firstLine.components(separatedBy: separatorsIn).count
        
        // Create the arrays to go into dataArray
        
        if numberOfColumns > 0 {
            for _ in 1...numberOfColumns {
                let newArray: [Double] = []
                localData.append(newArray)
            }
        } else {return localData}
        
        // Now that we have the columns to store our data, lets parse our data and put it in.
        // Iterate over each line in the lines array
        for nextLine in lines {
            // make sure the string isn't an empty string
            if nextLine == "" {continue}
            
            // use componets(separatedBy:) again to separate each line into an array of String Components
            let columnData = nextLine.components(separatedBy: parseSeparator.characterset)
            // Make sure we still have the correct number of columns
            if columnData.count != localData.count {
                return localData
            }
            
            // use .enumerated() to get both the index and the data at that index
            for (index, nextString) in columnData.enumerated() {
                
                // Remove any non-alphanumeric characters that might be hidden in the file/string
                let numberCharacters = CharacterSet(charactersIn: "0123456789,.-")
                
                //let allowedCharacters = CharacterSet.alphanumerics.union(.punctuationCharacters)
                //var filteredText = String(nextString.unicodeScalars.filter(allowedCharacters.contains))
                let filteredText = String(nextString.unicodeScalars.filter(numberCharacters.contains))

                if let nextData = Double(filteredText) {
                    localData[index].append(nextData)
                }
            }
        }
        
        return localData
    }
    
}
