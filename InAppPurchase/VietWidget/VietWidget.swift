//
//  VietWidget.swift
//  VietWidget
//
//  Created by MAC on 28/11/2023.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), remain: 0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, remain: 0)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        var noelDay = DateComponents()
        noelDay.day = 25
        noelDay.month = 12
        noelDay.year = 2023
        
        let noelDate = Calendar.current.date(from: noelDay)! // <2>
        print("DEBUG: \(noelDate)")

        let currentDay = Date()
        
        let currentDate = Date()
        for minute in 0 ..< 60 {
            
            let toNoel = noelDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970 - 60 * Double(minute)
            let entryDate = Calendar.current.date(byAdding: .minute, value: minute, to: .now)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, remain: toNoel)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var remain: Double
}

struct VietWidgetEntryView : View {
    var entry: Provider.Entry
    
    
    var body: some View {
        Text(convertMinutesToDaysMonthsHoursMinutes(entry.remain))
            .transition(.push(from: .bottom))

    }
    
    func convertMinutesToDaysMonthsHoursMinutes(_ totalSeconds: Double) -> String {
        // Define constants
        let secondsInMinute: Double = 60
           let minutesInHour: Double = 60
           let hoursInDay: Double = 24
           let daysInMonth: Double = 30  // Adjust based on your criteria for the number of days in a month
           
           // Calculate days, months, hours, and remaining minutes
           let minutes = totalSeconds / secondsInMinute
           let hours = minutes / minutesInHour
           let days = hours / hoursInDay
           let months = days / daysInMonth
           
           let remainingDays = Int(days.truncatingRemainder(dividingBy: daysInMonth))
           let remainingHours = Int(hours.truncatingRemainder(dividingBy: hoursInDay))
           let remainingMinutes = Int(minutes.truncatingRemainder(dividingBy: minutesInHour))

           // Create a formatted string
           let resultString = "\(Int(months)) months, \(remainingDays) days, \(remainingHours) hours, and \(remainingMinutes) minutes."
           
           return resultString
    }
}

@available(iOS 17.0, *)
struct VietWidget: Widget {
    let kind: String = "LockInlineWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            VietWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
                               .contentMarginsDisabled()
                               .supportedFamilies([ .systemLarge, .systemMedium,  .systemSmall])
        
    }
}

