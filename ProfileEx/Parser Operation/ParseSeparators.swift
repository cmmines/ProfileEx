//
//  ParseSeparators.swift
//  SimpleProfile
//
//  Created by Owen Hildreth on 12/29/21.
//

import Foundation
import SwiftUI


enum ParseSeparator: String, Codable, Hashable, CaseIterable, Identifiable {
    case colon
    case comma
    case semicolon
    case space
    case tab
    case whitespace
    
    var id: ParseSeparator { self }
    
    
    var characterset: CharacterSet {
        get {
            switch self {
            case .colon:
                return CharacterSet(charactersIn: ":")
            case .comma:
                return CharacterSet(charactersIn: ",")
            case .semicolon:
                return CharacterSet(charactersIn: ";")
            case .space:
                return CharacterSet(charactersIn: " ")
            case .tab:
                return CharacterSet(charactersIn: "\t")
            case .whitespace:
                return CharacterSet.whitespaces
            }
        }
    }
    
    var name:String {
        get {
            switch self {
            case .colon:
                return "Colon"
            case .comma:
                return "Comma"
            case .semicolon:
                return "Semicolon"
            case .space:
                return "Space"
            case .tab:
                return "Tab"
            case .whitespace:
                return "Whitespace"
            }
        }
    }
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(name) }
}

