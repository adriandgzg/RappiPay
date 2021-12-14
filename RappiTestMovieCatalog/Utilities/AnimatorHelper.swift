//
//  AnimatorHelper.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//
import Foundation
import UIKit

class AnimatorHelper {
    
    enum TypeAnimationLayer: String {
        case shadowOpacity = "shadowOpacity"
        case anchorPoint = "anchorPoint"
        case backgroundColor = "backgroundColor"
        case backgroundFilters = "backgroundFilters"
        case borderColor = "borderColor"
        case borderWidth = "borderWidth"
        case bounds = "bounds"
        case compositingFilter = "compositingFilter"
        case contents = "contents"
        case contentsRect = "contentsRect"
        case cornerRadius = "cornerRadius"
        case doubleSided = "doubleSided"
        case filters = "filters"
        case frame = "frame"
        case hidden = "hidden"
        case mask = "mask"
        case masksToBounds = "masksToBounds"
        case opacity = "opacity"
        case position = "position"
        case shadowColor = "shadowColor"
        case shadowOffset = "shadowOffset"
        case shadowPath = "shadowPath"
        case shadowRadius = "shadowRadius"
        case sublayers = "sublayers"
        case sublayerTransform = "sublayerTransform"
        case transform = "transform"
        case rotation = "transform.rotation"
    }
    
    //Layer Animations
    static func animateLayer(layer: CALayer, fromValue: Any, toValue: Any, duration : TimeInterval = 0.3, type: TypeAnimationLayer, repeatCount: Float = 1) {
        let animation = CABasicAnimation(keyPath: type.rawValue)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: animation.keyPath)
    }
    
    static func animateGroupLayer(layer: CALayer, values: [(fromFalue: Any, toValue: Any, type: TypeAnimationLayer)], duration : TimeInterval = 0.3) {
        
        var animationsArray: [CABasicAnimation] = []
        for value in values {
            let animation = CABasicAnimation(keyPath: value.type.rawValue)
            animation.fromValue = value.fromFalue
            animation.toValue = value.toValue
            animationsArray.append(animation)
        }
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = animationsArray
        layer.add(group, forKey: "AnimationGroup")
    }
    
    
    // View Animations
    
    static func squareAnimation(view: UIView, completion : (() -> Void)?){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            view.frame.origin.x += 10
        }, completion: { finished in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: [], animations: {
                view.frame.origin.x -= 10
                completion?()
            }, completion: nil)
        })
    }
    
    
    static func fadeTransition(view: UIView ,_ duration:CFTimeInterval){
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        view.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    
    static func fadeOut(view: UIView, speed : Double, delay: Double = 0.0 , completion : (() -> Void)?){
        
        UIView.animate(withDuration: speed, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            view.alpha = 0.0
            
        }, completion: { (success) in
            
            if completion != nil {
                completion!()
            }
        })
    }
    
    static func fadeIn(view: UIView, speed : Double, delay: Double = 0.0 , completion : (() -> Void)?){
        
        UIView.animate(withDuration: speed, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            view.alpha = 1.0
            
        }, completion: { (success) in
            
            if completion != nil {
                completion!()
            }
        })
    }
}
