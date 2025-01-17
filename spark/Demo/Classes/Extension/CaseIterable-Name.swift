//
//  CaseIterable-Name.swift
//  SparkDemo
//
//  Created by michael.zimmermann on 17.07.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation

extension CaseIterable {
    var name: String {
        return "\(self)".capitalizingFirstLetter
    }
}

extension String {
    var capitalizingFirstLetter: String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
