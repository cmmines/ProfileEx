//
//  DGDataColumnExtension.swift
//  SimpleProfile
//
//  Created by Owen Hildreth on 12/28/21.
//

extension DGDataColumn {
    func setDataFrom(_ values: [Double]) {
        self.setDataFrom(values.map( {String($0)} ))
    }
}
