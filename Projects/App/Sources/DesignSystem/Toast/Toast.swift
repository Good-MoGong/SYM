//
//  Toast.swift
//  SYM
//
//  Created by 민근의 mac on 2/13/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 1.5
}

enum ToastStyle {
    case error
    case warning
    case success
    case info
    
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .info: return Color.blue
        case .warning: return Color.orange
        case .success: return Color.green
        }
    }
    
    var iconStyle: String {
        switch self {
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
}
