//
//  Style.swift
//  conduit
//
//  Created by Nisha Masharani on 4/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

struct StyleColor {
  
  // Theme colors
//  let primary : UIColor = UIColor(hue: 197.0, saturation: 36.0, brightness: 51.0, alpha: 100.0)
//  let secondary : UIColor = UIColor(hue: 314.0, saturation: 48.0, brightness: 39.0, alpha: 100.0)
//  let accent : UIColor = UIColor(hue: 37.0,  saturation: 85.0, brightness: 88.0, alpha: 100.0)
//  let grey : UIColor = UIColor(hue: 0.0,   saturation: 0.0,  brightness: 25.0, alpha: 100.0)
  
  enum Brightness {
    case Light, Medium, Dark
  }
  
  enum Color {
    case Primary, Secondary, Accent, Grey, Error
  }
  
  static func getColor(color : Color, brightness : Brightness) -> UIColor {
    var curColor : UIColor
    switch color {
      case .Primary:
        switch brightness {
          case .Dark:
            return UIColor(hue: 203.0/360.0, saturation: 40.0/100.0, brightness: 30.0/100.0, alpha: 1.0)
          case .Medium:
            return UIColor(hue: 203.0/360.0, saturation: 40.0/100.0, brightness: 50.0/100.0, alpha: 1.0)
          case .Light:
            return UIColor(hue: 203.0/360.0, saturation: 40.0/100.0, brightness: 70.0/100.0, alpha: 1.0)
        }
      case .Secondary:
        switch brightness {
          case .Dark:
            return UIColor(hue: 314.0/360.0, saturation: 48.0/100.0, brightness: 19.0/100.0, alpha: 1.0)
          case .Medium:
            return UIColor(hue: 314.0/360.0, saturation: 48.0/100.0, brightness: 39.0/100.0, alpha: 1.0)
          case .Light:
            return UIColor(hue: 314.0/360.0, saturation: 48.0/100.0, brightness: 59.0/100.0, alpha: 1.0)
        }
      case .Accent:
        switch brightness {
          case .Dark:
            return UIColor(hue: 37.0/360.0,  saturation: 85.0/100.0, brightness: 68.0/100.0, alpha: 1.0)
          case .Medium:
            return UIColor(hue: 37.0/360.0,  saturation: 85.0/100.0, brightness: 88.0/100.0, alpha: 1.0)
          case .Light:
            return UIColor(hue: 37.0/360.0,  saturation: 85.0/100.0, brightness: 100.0/100.0, alpha: 1.0)
        }
      case .Grey:
        switch brightness {
          case .Dark:
            return UIColor(hue: 0.0,   saturation: 0.0,  brightness: 25.0/100.0, alpha: 1.0)
          case .Medium:
            return UIColor(hue: 0.0,   saturation: 0.0,  brightness: 45.0/100.0, alpha: 1.0)
          case .Light:
            return UIColor(hue: 0.0,   saturation: 0.0,  brightness: 85.0/100.0, alpha: 1.0)
        }
      case .Error:
        return UIColor(hue:9.0, saturation: 95.0, brightness:82.0/100.0, alpha:1.0)
    }
  }
};

struct TextColor {
  enum Brightness {
    case Light, Medium, Dark
  }
  
  static func getTextColor(brightness: Brightness) -> UIColor {
    switch brightness {
      case .Light:
        return UIColor.whiteColor()
      case .Medium:
        return StyleColor.getColor(.Grey, brightness: .Medium)
      case .Dark:
        return StyleColor.getColor(.Grey, brightness: .Dark)
    }
  }
}

class StyleHelpers {
  static let FONT_NAME = "SourceSansPro-Light"
  static let FONT_SIZE : CGFloat = 15.0
  
  class func setButtonFont(button : UIButton) {
    button.titleLabel!.font = UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)
  }
  
}