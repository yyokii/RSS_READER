//
//  NSDate+Extension.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/14.
//  Copyright © 2016年 yoki. All rights reserved.
//

import Foundation

extension Date {
    
    static func convertDateFromString (_ dateString:String) -> Date {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        inputFormatter.locale = Locale(identifier: "en_US")
        let date: Date! = inputFormatter.date(from: dateString)
        return date
    }
    
    func convertStringFromDate () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy/MM/dd HH:mm"
        let outputString = formatter.string(from: self)
        return outputString
    }
    
}
