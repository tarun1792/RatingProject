//
//  RatingView.swift
//  Stamurai Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RatingView:UIControl{
    var minValue: CGFloat = 0{
      didSet {
         updateLayerFrames()
      }
    }
    
    var maxValue: CGFloat = 0.9{
      didSet {
         updateLayerFrames()
      }
    }
    
    var lowerValue: CGFloat = 0.0{
      didSet {
         updateLayerFrames()
      }
    }
    
    var upperValue: CGFloat = 0.9{
      didSet {
         updateLayerFrames()
      }
    }
    
    var trackTintColor = UIColor(white: 0.9, alpha: 1) {
      didSet {
        trackLayer.setNeedsDisplay()
      }
    }
    
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
      didSet {
        trackLayer.setNeedsDisplay()
      }
    }
    
    var pointLabels:[UILabel] = {
        let count = 10
        var labels:[UILabel] = []
        
        for i in 0..<count{
            let label = UILabel()
            label.text = "\(i)"
            label.textAlignment = .center
            labels.append(label)
        }
        
        return labels
    }()
    
    private var previousLocation = CGPoint()

    override var frame: CGRect {
      didSet {
         updateLayerFrames()
      }
    }
    
    @IBInspectable
    var thumbImage:UIImage = #imageLiteral(resourceName: "dot"){
        didSet{
            upperRangeImageView.image = thumbImage
            lowerRangeImageView.image = thumbImage
            updateLayerFrames()
        }
    }
    
    //layer setup
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerRangeImageView:UIImageView = UIImageView()
    private let upperRangeImageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
      for label in self.pointLabels{
        addSubview(label)
      }
      
      trackLayer.rangeSlider = self
      trackLayer.contentsScale = UIScreen.main.scale
      layer.addSublayer(trackLayer)
      
      lowerRangeImageView.image = thumbImage
      addSubview(lowerRangeImageView)
      
      upperRangeImageView.image = thumbImage
      addSubview(upperRangeImageView)
        
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
   
    
    private func updateLayerFrames() {
      CATransaction.begin()
      CATransaction.setDisableActions(true)

      trackLayer.frame = bounds.insetBy(dx: 20.0, dy: bounds.height / 3)
      trackLayer.setNeedsDisplay()
      lowerRangeImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                         size: CGSize(width: 40, height: 40))
      upperRangeImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                         size: CGSize(width: 40, height: 40))
            
      CATransaction.commit()
         
      UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
             
            self.setupLabelTexts()
            
         }) { (success) in
        }
    }
   
    func positionForValue(_ value: CGFloat) -> CGFloat {
        let range = trackLayer.bounds.width/CGFloat(pointLabels.count - 1)
        return (range * value * 10) + 20
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
      let x = positionForValue(value) - upperRangeImageView.bounds.size.width / 2.0
      return CGPoint(x: x, y: (bounds.height - upperRangeImageView.bounds.size.height) / 2.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
    }
    
    private func labelOriginForValue(_ value: CGFloat)->CGPoint{
        let range = trackLayer.frame.width/CGFloat(pointLabels.count - 1)
        let x = (range * value) + 15
        return CGPoint(x: x , y: -1 * (bounds.height + 10))
    }
    
    private func setupLabelTexts() {
        
           for i in 0 ..< self.pointLabels.count{
               let label = self.pointLabels[i]
               if (i == Int(self.lowerValue * 10)){
                label.frame = CGRect(origin: CGPoint(x:labelOriginForValue(CGFloat(i)).x,y: -1 * (self.bounds.height + 25)), size: CGSize(width: 15, height: 15))
                   label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
               }else if (i == Int(self.upperValue * 10)){
                   label.frame = CGRect(origin: CGPoint(x:labelOriginForValue(CGFloat(i)).x,y: -1 * (self.bounds.height + 25)), size: CGSize(width: 15, height: 15))
                   label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
               }else{
                   label.frame = CGRect(origin:self.labelOriginForValue(CGFloat(i)), size: CGSize(width: 15, height: 15))
                   label.font = UIFont.systemFont(ofSize: 12, weight: .light)
               }
           }
       }
}

extension RatingView {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        previousLocation = touch.location(in: self)
        
        let upperFrame = upperRangeImageView.frame
        let newUpperFrame = CGRect(origin: upperFrame.offsetBy(dx: -30, dy: -30).origin, size: CGSize(width: 100, height: 100))
        
        let lowerFrame = lowerRangeImageView.frame
        let newLowerFrame = CGRect(origin: lowerFrame.offsetBy(dx: -30, dy: -30).origin, size: CGSize(width: 100, height: 100))
    
        if newLowerFrame.contains(previousLocation) {
          lowerRangeImageView.isHighlighted = true
        } else if newUpperFrame.contains(previousLocation) {
          upperRangeImageView.isHighlighted = true
        }

        return lowerRangeImageView.isHighlighted || upperRangeImageView.isHighlighted
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
       let location = touch.location(in: self)
   
       let deltaLocation = location.x - previousLocation.x
       let deltaValue = (maxValue - minValue) * deltaLocation / bounds.width
       
       previousLocation = location
       
       if lowerRangeImageView.isHighlighted {
         lowerValue += deltaValue
         lowerValue = boundValue(lowerValue, toLowerValue: minValue,
                                 upperValue: upperValue)
       } else if upperRangeImageView.isHighlighted {
         upperValue += deltaValue
         upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                                 upperValue: maxValue)
       }
        
        self.sendActions(for: .valueChanged)
        return true
     }
     
     override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
       lowerValue = round(lowerValue * 10) * 0.1
       upperValue = round(upperValue * 10) * 0.1
       lowerRangeImageView.isHighlighted = false
       upperRangeImageView.isHighlighted = false
       self.sendActions(for: .valueChanged)
     }
     
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
       return min(max(value, lowerValue), upperValue)
     }
}
