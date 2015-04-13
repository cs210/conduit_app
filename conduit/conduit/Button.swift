//
//  Button.swift
//  conduit
//
//  Created by Nisha Masharani on 4/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class Button : UIButton {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.tintColor = TextColor.getTextColor(.Light)
    self.backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
  }
}