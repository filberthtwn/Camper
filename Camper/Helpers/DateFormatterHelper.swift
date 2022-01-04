//
//  DateFormatterHelper.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation

class DateformatterHelper{
    static let shared = DateformatterHelper()
    
//    func formatString(oldDateFormat:String, newDateFormat:String, dateString:String, fromTimezone:TimeZone?, toTimezone:TimeZone?)->String{
//        let dfGet = DateFormatter()
//        dfGet.dateFormat = oldDateFormat
//        dfGet.timeZone = TimeZone(identifier: "UTC")
//        if let fromTimezone = fromTimezone {
//            dfGet.timeZone = fromTimezone
//        }
//
//        let dfPrint = DateFormatter()
//        dfPrint.dateFormat = newDateFormat
//        dfPrint.locale = Locale.current
//        if let toTimezone = toTimezone{
//            dfPrint.timeZone = toTimezone
//        }
//
//        let dateGet = dfGet.date(from: dateString)
//        return dfPrint.string(from: dateGet!)
//    }
    
    func formatISO8601(newDateFormat:String, dateString:String, timezone:TimeZone?)->String{
        let dfGet = DateFormatter()
        dfGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dfGet.timeZone = TimeZone(identifier: "UTC")
        
        let dfPrint = DateFormatter()
        dfPrint.dateFormat = newDateFormat
        dfPrint.timeZone = TimeZone.current
        if let timezone = timezone{
            dfPrint.timeZone = timezone
        }

        let dateGet = dfGet.date(from: dateString)
        return dfPrint.string(from: dateGet!)
    }
}
