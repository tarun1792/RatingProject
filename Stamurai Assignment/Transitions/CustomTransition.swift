//
//  CustomTransactions.swift
//  Stamurai Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit

class CustomTransition: NSObject{
    public var duration = 0.5
    public var alphaComponent:CGFloat = 1.0
    
    var mode:TransitionMode = .present
    var animationStyle:AnimationStyle = .plane
    var scaleUpFactor:CGFloat = 2
    var scaleDownFactor:CGFloat = 0.9
    
    enum TransitionMode{
        case present
        case dismiss
    }
    
    enum AnimationStyle{
        case scaleUp
        case scaleDown
        case plane
        case bottomUp
        case topDown
    }
}

extension CustomTransition:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        containerView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.bounds.height + containerView.frame.minY)
        
        toView?.frame = containerView.frame
        
        if mode == .dismiss{
            
            containerView.insertSubview(toView!, at: 0)
            toView?.alpha = alphaComponent
            
            toView?.transform = self.toViewTransformForAnimationStyle(containerView)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                fromView?.transform = self.fromViewTransformForAnimationStyle(containerView)
                toView?.transform = .identity
                toView?.alpha = self.alphaComponent
            }) { (success) in
                    toView?.transform = .identity
                    fromView?.transform = .identity
                    transitionContext.completeTransition(success)
            }
        }
        
        
        if mode == .present{
            toView?.transform = self.toViewTransformForAnimationStyle(containerView)
            
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                    toView?.transform = CGAffineTransform.identity
                    fromView?.transform = self.fromViewTransformForAnimationStyle(containerView)
                    fromView?.alpha = self.alphaComponent
            }) { (success) in
                    toView?.transform = .identity
                    fromView?.transform = .identity
                    transitionContext.completeTransition(success)
            }
        }
    }
    
    
    private func toViewTransformForAnimationStyle(_ view:UIView)->CGAffineTransform{
        var transform:CGAffineTransform!
        
        switch animationStyle{
        case .plane:
            transform = CGAffineTransform.identity
            break
        case .scaleUp:
            transform = CGAffineTransform.init(scaleX:scaleUpFactor , y: scaleUpFactor)
            break
        case .scaleDown:
            transform = CGAffineTransform.init(translationX: 0, y: view.bounds.height)
            
        case .topDown:
            transform = CGAffineTransform.init(translationX: 0, y: -1 * view.bounds.height )
            
        case .bottomUp:
            transform = CGAffineTransform.init(translationX: 0, y: view.bounds.height)
        }
    
        return transform
    }
    
    private func fromViewTransformForAnimationStyle(_ view:UIView)->CGAffineTransform{
        var transform:CGAffineTransform!
        
        switch animationStyle{
        case .plane:
            transform = CGAffineTransform.identity
            break
        case .scaleUp:
            transform = CGAffineTransform.init(translationX: 0, y: view.bounds.height)
            break
        case .scaleDown:
            transform = CGAffineTransform.init(scaleX: scaleUpFactor, y: scaleUpFactor)
            
        case .topDown:
            transform = CGAffineTransform.init(translationX: 0, y: view.bounds.height)
            
        case .bottomUp:
            transform = CGAffineTransform.init(translationX: 0, y: -1 * view.bounds.height)
        }
        
        return transform
    }
    
}

