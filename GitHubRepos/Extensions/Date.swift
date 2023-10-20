//
//  Date.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

extension Date {
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    static var dayAgoDateString: String {
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return "" }
        return dateFormatter.string(from: date)
    }
    
    static var weekAgoDateString: String {
        guard let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return "" }
        return dateFormatter.string(from: date)
    }
    
    static var monthAgoDateString: String {
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return "" }
        return dateFormatter.string(from: date)
    }
}
