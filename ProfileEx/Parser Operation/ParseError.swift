//
//  ParseError.swift
//  SimpleProfile
//
//  Created by Owen Hildreth on 12/29/21.
//


extension FileParser {
    enum ParseError: Error {
        case noStringInURL
        case notEnoughColumns
        case tooManyColumns
    }
}
