//
//  KeyPathExtension.swift
//  SYM
//
//  Created by 민근의 mac on 2/15/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

extension KeyPath {
    var toKeyName: String {
        guard let propertyName = self.debugDescription.split(separator: ".").last else { return "" }
        return String(propertyName)
    }
}
