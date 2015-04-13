//
//  Label.swift
//  conduit
//
//  Created by Nisha Masharani on 4/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class Label : UILabel {
  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    self.textColor = TextColor.getTextColor(.Dark)
  }
}