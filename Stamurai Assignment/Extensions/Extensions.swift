//
//  RatingBackgroundView.swift
//  Stamurai Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func createGradientWith(_ colors:[CGColor]){
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.8).cgColor,UIColor.white.withAlphaComponent(0.25).cgColor]
        gradientLayer.frame  = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addCornerRadius(of value:CGFloat){
        self.layer.cornerRadius  = value
        self.layer.masksToBounds = true
    }
    
    func addCornerRadius(of value:CGFloat,withBorderWidth width:CGFloat,color:UIColor){
        self.layer.cornerRadius  = value
        self.layer.borderColor   = color.cgColor
        self.layer.borderWidth   = width
        self.layer.masksToBounds = true
    }
    
    func addShadowWith(cornerRadius radius:CGFloat,shadow shadowRadius:CGFloat,color:UIColor,offset:CGSize,opacity:Float){
        self.layer.cornerRadius = radius
        self.layer.shadowColor  = color.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
}


