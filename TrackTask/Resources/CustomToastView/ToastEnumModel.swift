//
//  ToastEnumModel.swift
//  DailyTask
//
//  Created by Dinesh Dev on 19/07/24.
//

import Foundation
import SwiftUI

struct CustomToast: Equatable {
    var type: ToastEnumModel
    var title: String
    var message: String
    var duration: Double = 3
}

struct CustomToastModel {
    var isValid: Bool
    var title: String
    var message: String
}

enum ToastEnumModel {
    case error
    case warning
    case success
    case info
}

extension ToastEnumModel {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
   
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
