//
//  RangeSliderTrackerLayer.swift
//  Rating Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit


class RangeSliderTrackLayer: CALayer {
  weak var rangeSlider: RatingView?
  
  override func draw(in ctx: CGContext) {
    guard let slider = rangeSlider else {
      return
    }
    
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    ctx.addPath(path.cgPath)
    
    ctx.setFillColor(slider.trackTintColor.cgColor)
    ctx.fillPath()
    
    ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
    let lowerValuePosition = slider.positionForValue(slider.lowerValue)
    let upperValuePosition = slider.positionForValue(slider.upperValue)
    let rect = CGRect(x: lowerValuePosition, y: 0,
                      width: upperValuePosition - lowerValuePosition,
                      height: bounds.height)
    ctx.fill(rect)
  }
}
