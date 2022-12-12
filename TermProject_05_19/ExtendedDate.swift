//
//  ExtendedDate.swift
//  ch09-1871453-tableView
//
//  Created by SJH on 2022/04/27.
//

import Foundation
//시간날 때 코드한번 읽어보기
extension Date{
    
    static  let calendar = Calendar(identifier: .gregorian)
    static  let dateFormatter = DateFormatter()
    
    func setCurrentTime() -> Date{
        let current = Date.calendar.dateComponents([.hour, .minute, .second], from: Date())
        var components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(current.hour, for: .hour)
        components.setValue(current.minute, for: .minute)
        components.setValue(current.second, for: .second)
        return Date.calendar.date(from: components)!
    }

    func firstOfDay() -> Date{
        let components = Date.calendar.dateComponents([.year, .month, .day], from: self)// componets는 dataComponents함수를 이용하여 .year.month.day값을 가져온다
        return Date.calendar.date(from: components)!
    }
    func lastOfDay() -> Date{
        var components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        return Date.calendar.date(from: components)!
    }
        
    func firstOfWeek() -> Date{
        let components = Date.calendar.dateComponents([.year, .month, .weekday], from: self)
        let first = self - TimeInterval((components.weekday! - 1)*24*60*60)
        return first.firstOfDay()
    }
    
    func lastOfWeek() -> Date{
        let components = Date.calendar.dateComponents([.year, .month, .weekday], from: self)
        let last = self + TimeInterval((7-components.weekday!)*24*60*60)
        return last.lastOfDay()
    }
    
    func firstOfMonth() -> Date{
        let components = Date.calendar.dateComponents([.year, .month], from: self)
        return Date.calendar.date(from: components)!
    }
    
    func lastOfMonth() -> Date{
        let lastDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        var components = Date.calendar.dateComponents([.year, .month], from: self)
        let lastDay = lastDays[components.month! - 1]
        components.setValue(lastDay, for: .day)
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        return Date.calendar.date(from: components)!
    }

    func toStringMonth() -> String{
        Date.dateFormatter.dateFormat = "yyyy-MM"
        return Date.dateFormatter.string(from: self)
    }
    
    func toStringDate() -> String{
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.string(from: self)
    }
    
    func toStringDateTime() -> String{
        Date.dateFormatter.dateFormat = "MM-dd HH:mm"
        return Date.dateFormatter.string(from: self)
    }
}
