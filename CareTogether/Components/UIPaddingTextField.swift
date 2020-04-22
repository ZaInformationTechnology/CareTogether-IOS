//
//  UIPaddingTextField.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 21/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class UIPaddingTextField : UITextField {

  let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
