//
//  UsefulFunctions.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 10/05/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.mainScreen().bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

class UseFulFunctions
{
    class func string2nsdate(str: String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return dateFormatter.dateFromString(str) as NSDate!
    }
    
    class func string2nsdateMini(str: String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return dateFormatter.dateFromString(str) as NSDate!
    }
    
    /** Retorna somente as horas e minutos */
    class func getStringDateFromDate(date: NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.stringFromDate(date)
        
        return date
    }
}








