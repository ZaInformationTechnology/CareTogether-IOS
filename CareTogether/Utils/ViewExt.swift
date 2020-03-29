//
//  ViewExt.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

extension UIView {
func animatePress(){
    self.alpha = 0.2
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: [.curveLinear, .allowUserInteraction],
                   animations: {
                    self.alpha = 1
    })
}
    func embed(_ viewController:UIViewController, inParent controller:UIViewController){
       viewController.willMove(toParent: controller)
        viewController.view.frame = self.bounds
        self.addSubview(viewController.view)
       controller.addChild(viewController)
       viewController.didMove(toParent: controller)
    }
    func roundedTopLeft(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }

       func roundedTopRight(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topRight],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedBottomLeft(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.bottomLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedBottomRight(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.bottomRight],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedBottom(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.bottomRight , .bottomLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedTop(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topRight , .topLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedLeft(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topLeft , .bottomLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedRight(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topRight , .bottomRight],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
       func roundedAllCorner(){
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topRight , .bottomRight , .topLeft , .bottomLeft],
                                        cornerRadii: CGSize(width: 15, height: 15))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
}
