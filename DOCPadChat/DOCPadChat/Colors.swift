//
//  Colors.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

let blueColor = UIColor.init(netHex: 0x1ABBF5)
let grayColor = UIColor.init(netHex: 0x9fa3a4)

let color0 = UIColor.init(netHex: 0x151414)
let color1 = UIColor.init(netHex: 0xb1afaf)
let color2 = UIColor.init(netHex: 0x007aff)
let color3 = UIColor.init(netHex: 0x6caf47)
let color4 = UIColor.init(netHex: 0x6de0ff)
let color5 = UIColor.init(netHex: 0xed2130)
let color6 = UIColor.init(netHex: 0xff9500)
let color7 = UIColor.init(netHex: 0xff2d86)
let color8 = UIColor.init(netHex: 0xf8edb9)
let color9 = UIColor.init(netHex: 0x8659f7)
let color10 = UIColor.init(netHex: 0xf6f5f9)
let color11 = UIColor.init(netHex: 0x009fb8)

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}