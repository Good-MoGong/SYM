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
        let keyPathString = String(reflecting: self)
        let components = keyPathString.components(separatedBy: ".")
        
        guard let lastComponent = components.last else { return "" }
        return lastComponent
    }
}
