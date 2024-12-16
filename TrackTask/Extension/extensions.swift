//
//  extensions.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import Foundation


import SwiftUI

extension View {
    func commonStyle(
        radius: CGFloat = 10,
        borderColor: Color = .gray.opacity(0.3),
        borderWidth: CGFloat = 1,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: CGFloat = 10,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 3
    ) -> some View {
        self
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
    }
}

func formatDateToString(date: Date,format:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Format for hours, minutes, and AM/PM
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}


func displaySelectedDateAndTime(taskDate: Date) -> String {
        // Combine the selected date and time
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let dateString = DateFormatter.dateFormatter.string(from: taskDate)
        let timeString = DateFormatter.timeFormatter.string(from: taskDate)
        
        if calendar.isDate(taskDate, inSameDayAs: today) {
            return "Today at \(timeString)"
        } else if calendar.isDate(taskDate, inSameDayAs: tomorrow) {
            return "Tomorrow at \(timeString)"
        } else {
            return "\(dateString) at \(timeString)"
        }
    }
