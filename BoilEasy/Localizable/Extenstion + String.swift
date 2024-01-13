//
//  Extenstion + String.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 13.01.2024.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
