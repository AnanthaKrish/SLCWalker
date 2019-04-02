//
//  CALayer+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/3/25.
//  Copyright © 2019 SecretLisa. All rights reserved.
//
//  链式方式加载动画,以下功能以MARK为分类作划分.
//  本项目会长期维护更新.
//  (1)MAKE类,全部是以中心点为依据的动画.
//  (2)TAKE类,全部以边界点为依据.(此时暂时repeat参数是无效的,待后续处理).
//  (3)MOVE类,相对移动 (以中心点为依据).
//  (4)ADD类,相对移动(以边界为依据).
//  (5)通用是适用于所有类型的动画样式.
//  (6)不使用then参数,同时使用多个动画如makeWith(20).animate(1).makeHeight(20).animate(1)
//  会同时作用; 使用then参数时如makeWith(20).animate(1).then.makeHeight(20).animate(1)
//  会在动画widtha完成后再进行动画height
//  (7)TRANSITION 转场动画.
//
//  注: 如果没有特殊注释,则表示参数适用于所有类型.
//
//
//  The animation is loaded in a chained manner. The following functions are classified by MARK.
//  This project will maintain and update for a long time.
//  (1)MAKE, all based on the animation of the center point.
//  (2)TAKE, all based on the boundary point. (At this time, the temporary repeat parameter is invalid, to be processed later)
//  (3)MOVE, relative movement (based on the center point).
//  (4)ADD, relative movement (based on the boundary).
//  (5)Universal is for all types of animated styles.
//  (6)Do not use the then parameter and use multiple animations at the same time, Such as
//  makeWith(20).animate(1).makeHeight(20).animate(1), Will work at the same time.
//  When using the then parameter, Such as makeWith(20).animate(1).then.makeHeight(20).animate(1)
//  Will be animated height after the animation widtha is completed.
//  (7)Transition animation.
//
//  Note: If there are no special comments, the parameters apply to all types.
//
//

import UIKit
import ObjectiveC.runtime


private func slc_baseWalker(keyPath: String,
                    duration: TimeInterval,
                    repeatCount: Float,
                    delay: TimeInterval,
                    autoreverses: Bool,
                    timing: CAMediaTimingFunctionName,
                    from: Any?,
                    to: Any?) -> CABasicAnimation
{
    let base: CABasicAnimation = CABasicAnimation(keyPath: keyPath)
    base.isRemovedOnCompletion = false
    base.duration = duration
    base.repeatCount = repeatCount
    base.fillMode = CAMediaTimingFillMode.forwards
    base.beginTime = CACurrentMediaTime() + delay
    base.timingFunction = CAMediaTimingFunction(name: timing)
    base.autoreverses = autoreverses
    base.fromValue = from
    base.toValue = to
    return base
}

private func slc_springWalker(keyPath: String,
                              duration: TimeInterval,
                              repeatCount: Float,
                              delay: TimeInterval,
                              autoreverses: Bool,
                              timing: CAMediaTimingFunctionName,
                              from: Any?,
                              to: Any?) -> CASpringAnimation
{
    let spring: CASpringAnimation = CASpringAnimation(keyPath: keyPath)
    spring.isRemovedOnCompletion = false
    spring.duration = duration
    spring.repeatCount = repeatCount
    spring.fillMode = CAMediaTimingFillMode.forwards
    spring.beginTime = CACurrentMediaTime() + delay
    spring.timingFunction = CAMediaTimingFunction(name: timing)
    spring.autoreverses = autoreverses
    spring.fromValue = from
    spring.toValue = to
    spring.mass = 1.0
    spring.stiffness = 100
    spring.damping = 10
    spring.initialVelocity = 10
    return spring
}

private func slc_keyframeWalker(keyPath: String,
                                duration: TimeInterval,
                                repeatCount: Float,
                                delay: TimeInterval,
                                autoreverses: Bool,
                                timing: CAMediaTimingFunctionName,
                                path: CGPath?) -> CAKeyframeAnimation
{
    let keyframe: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
    keyframe.isRemovedOnCompletion = false
    keyframe.duration = duration
    keyframe.repeatCount = repeatCount
    keyframe.fillMode = CAMediaTimingFillMode.forwards
    keyframe.beginTime = CACurrentMediaTime() + delay
    keyframe.timingFunction = CAMediaTimingFunction(name: timing)
    keyframe.autoreverses = autoreverses
    keyframe.path = path
    return keyframe
}

private func slc_transitionWalker(duration: TimeInterval,
                                  timing: CAMediaTimingFunctionName,
                                  type: SLCWalkerTransitionType,
                                  direction: SLCWalkerTransitionDirection,
                                  repeatCount: Float,
                                  delay: TimeInterval,
                                  autoreverses: Bool) -> CATransition
{
    let transition: CATransition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: timing)
    transition.type = type
    transition.subtype = direction
    transition.repeatCount = repeatCount
    transition.beginTime = CACurrentMediaTime() + delay
    transition.autoreverses = autoreverses
    return transition
}


private var SLCWalkerCompletionKey: String = "slc.completion"

private let SLCWalkerKeyPathPosition: String = "position"
private let SLCWalkerKeyPathPositionX: String = "position.x"
private let SLCWalkerKeyPathPositionY: String = "position.y"
private let SLCWalkerKeyPathWidth: String = "bounds.size.width"
private let SLCWalkerKeyPathHeight: String = "bounds.size.height"
private let SLCWalkerKeyPathSize: String = "bounds.size"
private let SLCWalkerKeyPathScale: String = "transform.scale"
private let SLCWalkerKeyPathScaleX: String = "transform.scale.x"
private let SLCWalkerKeyPathScaleY: String = "transform.scale.y"
private let SLCWalkerKeyPathRotationX: String = "transform.rotation.x"
private let SLCWalkerKeyPathRotationY: String = "transform.rotation.y"
private let SLCWalkerKeyPathRotationZ: String = "transform.rotation.z"
private let SLCWalkerKeyPathBackground: String = "backgroundColor"
private let SLCWalkerKeyPathOpacity: String = "opacity"
private let SLCWalkerKeyPathCornerRadius: String = "cornerRadius"
private let SLCWalkerKeyPathStrokeEnd: String = "strokeEnd"
private let SLCWalkerKeyPathContent: String = "contents"
private let SLCWalkerKeyPathBorderWidth: String = "borderWidth"
private let SLCWalkerKeyPathShadowColor: String = "shadowColor"
private let SLCWalkerKeyPathShadowOffset: String = "shadowOffset"
private let SLCWalkerKeyPathShadowOpacity: String = "shadowOpacity"
private let SLCWalkerKeyPathShadowRadius: String = "shadowRadius"

private let UIViewWalkerKeyFrame: String = "slc.take.frame"
private let UIViewWalkerKeyLeading: String = "slc.take.leading"
private let UIViewWalkerKeyTraing: String = "slc.take.traing"
private let UIViewWalkerKeyTop: String = "slc.take.top"
private let UIViewWalkerKeyBottom: String = "slc.take.bottom"
private let UIViewWalkerKeyWidth: String = "slc.take.width"
private let UIViewWalkerKeyHeight: String = "slc.take.height"
private let UIViewWalkerKeySize: String = "slc.take.size"


private let SLCWalkerTransitionTypeFade: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "fade")
private let SLCWalkerTransitionTypePush: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "push")
private let SLCWalkerTransitionTypeReveal: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "receal")
private let SLCWalkerTransitionTypeMoveIn: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "moveIn")
private let SLCWalkerTransitionTypeCube: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cube")
private let SLCWalkerTransitionTypeSuck: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "suckEffect")
private let SLCWalkerTransitionTypeRipple: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "rippleEffect")
private let SLCWalkerTransitionTypeCurl: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "pageCurl")
private let SLCWalkerTransitionTypeUnCurl: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "pageUnCurl")
private let SLCWalkerTransitionTypeFlip: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "oglFlip")
private let SLCWalkerTransitionTypeHollowOpen: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cameraIrisHollowOpen")
private let SLCWalkerTransitionTypeHollowClose: SLCWalkerTransitionType = SLCWalkerTransitionType(rawValue: "cameraIrisHollowClose")


public let SLCWalkerTransitionDirectionFromRight: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromRight")
public let SLCWalkerTransitionDirectionFromLeft: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromLeft")
public let SLCWalkerTransitionDirectionFromTop: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromTop")
public let SLCWalkerTransitionDirectionFromBottom: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromBottom")
public let SLCWalkerTransitionDirectionFromMiddle: SLCWalkerTransitionDirection = SLCWalkerTransitionDirection(rawValue: "fromMiddle")

private enum SLCWalkerType: Int
{
    case base = 0, spring, path, transition
}

private var my_animationType: SLCWalkerType  = SLCWalkerType.base
private var my_timing: CAMediaTimingFunctionName = CAMediaTimingFunctionName.linear
private var my_options: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear;
private var my_delay: TimeInterval = 0.0
private var my_myRepeatCount: Int = 1
private var my_reverses: Bool = false
private var my_isCAanimation: Bool = true
private var my_animateTime: TimeInterval = 0.25
private var my_currentKeyPath: String = SLCWalkerKeyPathPosition
private var my_from: Any? = nil
private var my_to: Any? = nil
private var my_viewWalkerkeyPath: String = UIViewWalkerKeyFrame
private var my_theWalker: SLCWalker = SLCWalker.makePosition
private var my_transitionType: SLCWalkerTransitionType = SLCWalkerTransitionTypeFade
private var my_frameOrigin: CGRect = CGRect.zero;

extension CALayer: CAAnimationDelegate
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
   @discardableResult func makePosition(_ point: CGPoint) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPosition
        my_from = CGPoint(x: self.centerX, y: self.centerY)
        my_to = point
        my_theWalker = SLCWalker.makePosition
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPositionX
        my_from = self.centerX
        my_to = x
        my_theWalker = SLCWalker.makeX
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPositionY
        my_from = self.centerY
        my_to = y
        my_theWalker = SLCWalker.makeY
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathWidth
        my_from = self.width
        my_to = width
        my_theWalker = SLCWalker.makeWidth
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathHeight
        my_from = self.height
        my_to = height
        my_theWalker = SLCWalker.makeHeight
        return self
    }
    
    @discardableResult func makeSize(_ size: CGSize) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathSize
        my_from = CGSize(width: self.width, height: self.height)
        my_to = size
        my_theWalker = SLCWalker.makeSize
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathScale
        my_from = 1.0
        my_to = scale
        my_theWalker = SLCWalker.makeScale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathScaleX
        my_from = 1.0
        my_to = scaleX
        my_theWalker = SLCWalker.makeScaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathScaleY
        my_from = 1.0
        my_to = scaleY
        my_theWalker = SLCWalker.makeScaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathRotationX
        my_from = 0
        my_to = rotationX
        my_theWalker = SLCWalker.makeRotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathRotationY
        my_from = 0
        my_to = rotationY
        my_theWalker = SLCWalker.makeRotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathRotationZ
        my_from = 0
        my_to = rotationZ
        my_theWalker = SLCWalker.makeRotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathBackground
        my_from = self.backgroundColor
        my_to = background
        my_theWalker = SLCWalker.makeBackground
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathOpacity
        my_from = self.opacity
        my_to = opacity
        my_theWalker = SLCWalker.makeOpacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathCornerRadius
        my_from = self.cornerRadius
        my_to = corner
        my_theWalker = SLCWalker.makeCornerRadius
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storleEnd: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathStrokeEnd
        my_from = 0
        my_to = storleEnd
        my_theWalker = SLCWalker.makeStrokeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathContent
        my_from = from
        my_to = to
        my_theWalker = SLCWalker.makeContent
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathBorderWidth
        my_from = self.borderWidth
        my_to = borderWidth
        my_theWalker = SLCWalker.makeBorderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ color: UIColor) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathShadowColor
        my_from = self.shadowColor
        my_to  = color
        my_theWalker = SLCWalker.makeShadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathShadowOffset
        my_from = self.shadowOffset
        my_to = shadowOffset
        my_theWalker = SLCWalker.makeShadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathShadowOpacity
        my_from = self.shadowOpacity
        my_to = shadowOpacity
        my_theWalker = SLCWalker.makeShadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRdius: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathShadowRadius
        my_from = self.shadowRadius
        my_to = shadowRdius
        my_theWalker = SLCWalker.makeShadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyFrame
        my_to = rect
        my_theWalker = SLCWalker.takeFrame
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyLeading
        my_to = leading
        my_theWalker = SLCWalker.takeLeading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyTraing
        my_to = traing
        my_theWalker = SLCWalker.takeTraing
        return self
    }

    @discardableResult func takeTop(_ top: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyTop
        my_to = top
        my_theWalker = SLCWalker.takeTop
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyBottom
        my_to = bottom
        my_theWalker = SLCWalker.takeBottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyWidth
        my_to = width
        my_theWalker = SLCWalker.takeWidth
        return self
    }
    
    @discardableResult func takeHeight(_ height:CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyHeight
        my_to = height
        my_theWalker = SLCWalker.takeHeight
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeySize
        my_to = size
        my_theWalker = SLCWalker.takeSize
        return self
    }

    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPositionX
        my_from = self.centerX
        my_to = self.centerX + x
        my_theWalker = SLCWalker.moveX
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPositionY
        my_from = self.centerY
        my_to = self.centerY + y
        my_theWalker = SLCWalker.moveY
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathPosition
        my_from = CGPoint(x: self.centerX, y: self.centerY)
        my_to = CGPoint(x: self.centerX + xy.x, y: self.centerY + xy.y)
        my_theWalker = SLCWalker.moveXY
        return self
    }

    @discardableResult func moveWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathWidth
        my_from = self.width
        my_to = self.width + width
        my_theWalker = SLCWalker.moveWidth
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathHeight
        my_from = self.height
        my_to = self.height + height
        my_theWalker = SLCWalker.moveHeight
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> CALayer
    {
        self.slc_resetInitParams()
        my_currentKeyPath = SLCWalkerKeyPathSize
        my_from = CGSize(width: self.width, height: self.height)
        my_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        my_theWalker = SLCWalker.moveSize
        return self
    }
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyLeading
        my_to = self.leading + leading
        my_theWalker = SLCWalker.addLeading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyTraing
        my_to = self.traing + traing
        my_theWalker = SLCWalker.addTraing
        return self
    }

    @discardableResult func addTop(_ top: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyTop
        my_to = self.top + top
        my_theWalker = SLCWalker.addTop
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyBottom
        my_to = self.bottom + bottom
        my_theWalker = SLCWalker.addBottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyWidth
        my_to = self.width + width
        my_theWalker = SLCWalker.addWidth
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeyHeight
        my_to = self.height + height
        my_theWalker = SLCWalker.addHeight
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> CALayer
    {
        self.slc_resetInitParams()
        my_isCAanimation = false
        my_viewWalkerkeyPath = UIViewWalkerKeySize
        my_to = CGSize(width: self.width + size.width, height: self.height + size.height)
        my_theWalker = SLCWalker.addSize
        return self
    }
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: SLCWalkerTransitionDirection) -> CALayer
    {
        self.slc_resetInitParams()
        my_to = dir
        my_animationType = SLCWalkerType.transition
        my_theWalker = SLCWalker.transition
        return self
    }
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> CALayer
    {
        self.slc_resetInitParams()
        my_to = apath
        my_animationType = SLCWalkerType.path
        my_theWalker = SLCWalker.path
        return self
    }

    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> CALayer
    {
        my_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> CALayer
    {
        my_myRepeatCount = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> CALayer
    {
        my_reverses = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> CALayer
    {
        my_animateTime = duration
        self.slc_startWalker()
        return self
    }
    
    
    var completion: SLCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerCompletionKey) as! SLCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCWalkerCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: CALayer {
        my_timing = CAMediaTimingFunctionName.easeInEaseOut
        my_options = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: CALayer {
        my_timing = CAMediaTimingFunctionName.easeIn
        my_options = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: CALayer {
        my_timing = CAMediaTimingFunctionName.easeOut
        my_options = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: CALayer {
        my_timing = CAMediaTimingFunctionName.linear
        my_options = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: CALayer {
        my_animationType = SLCWalkerType.spring
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效)
    // Transition animation style (only for TRANSITION, spring is unavailable)
    var transitionFade: CALayer {
        my_transitionType = SLCWalkerTransitionTypeFade
        return self
    }
    
    var transitionPush: CALayer {
        my_transitionType = SLCWalkerTransitionTypePush
        return self
    }
    
    var transitionReveal: CALayer {
        my_transitionType = SLCWalkerTransitionTypeReveal
        return self
    }
    
    var transitionMoveIn: CALayer {
        my_transitionType = SLCWalkerTransitionTypeMoveIn
        return self
    }
    
    var transitionCube: CALayer {
        my_transitionType = SLCWalkerTransitionTypeCube
        return self
    }
    
    var transitionSuck: CALayer {
        my_transitionType = SLCWalkerTransitionTypeSuck
        return self
    }
    
    var transitionRipple: CALayer {
        my_transitionType = SLCWalkerTransitionTypeRipple
        return self
    }
    
    var transitionCurl: CALayer {
        my_transitionType = SLCWalkerTransitionTypeCurl
        return self
    }
    
    var transitionUnCurl: CALayer {
        my_transitionType = SLCWalkerTransitionTypeUnCurl
        return self
    }
    
    var transitionFlip: CALayer {
        my_transitionType = SLCWalkerTransitionTypeFlip
        return self
    }
    
    var transitionHollowOpen: CALayer {
        my_transitionType = SLCWalkerTransitionTypeHollowOpen
        return self
    }
    
    var transitionHollowClose: CALayer {
        my_transitionType = SLCWalkerTransitionTypeHollowClose
        return self
    }
    
    
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: CALayer {
        my_delay = my_animateTime
        return self
    }
    
    
    func removeWalkers()
    {
        self.removeAllAnimations()
        if !my_isCAanimation
        {
            let superLayer = self.superlayer
            self.removeFromSuperlayer()
            self.frame = my_frameOrigin
            superLayer?.addSublayer(self)
        }
    }
    
    
    func reloadWalker()
    {
        self.removeWalkers()
        self.slc_startWalker()
    }
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            if my_isCAanimation
            {
                if my_animationType == SLCWalkerType.base
                {
                    let base: CABasicAnimation = slc_baseWalker(keyPath: my_currentKeyPath,
                                                                duration: my_animateTime,
                                                                repeatCount: Float(my_myRepeatCount),
                                                                delay: my_delay,
                                                                autoreverses: my_reverses,
                                                                timing: my_timing,
                                                                from: my_from,
                                                                to: my_to)
                    base.delegate = self
                    self.add(base, forKey: nil)
                }
                else if my_animationType == SLCWalkerType.spring
                {
                    let sp: CASpringAnimation = slc_springWalker(keyPath: my_currentKeyPath,
                                                                 duration: my_animateTime,
                                                                 repeatCount: Float(my_myRepeatCount),
                                                                 delay: my_delay,
                                                                 autoreverses: my_reverses,
                                                                 timing: my_timing,
                                                                 from: my_from,
                                                                 to: my_to)
                    sp.delegate = self
                    self.add(sp, forKey: nil)
                }
                else if my_animationType == SLCWalkerType.path
                {
                    let keyframe: CAKeyframeAnimation = slc_keyframeWalker(keyPath: my_currentKeyPath,
                                                                           duration: my_animateTime,
                                                                           repeatCount: Float(my_myRepeatCount),
                                                                           delay: my_delay,
                                                                           autoreverses: my_reverses,
                                                                           timing: my_timing,
                                                                           path: (my_to as! CGPath))
                    keyframe.delegate = self
                    self.add(keyframe, forKey: nil)
                }
                else if my_animationType == SLCWalkerType.transition
                {
                    let tr: CATransition = slc_transitionWalker(duration: my_animateTime,
                                                                timing: my_timing,
                                                                type: my_transitionType,
                                                                direction: (my_to as! SLCWalkerTransitionDirection),
                                                                repeatCount: Float(my_myRepeatCount),
                                                                delay: my_delay,
                                                                autoreverses: my_reverses)
                    tr.delegate = self
                    self.add(tr, forKey: nil)
                }
            }
            else
            {
                my_frameOrigin = self.frame
                if my_reverses
                {
                    if my_options == UIView.AnimationOptions.curveEaseInOut
                    {
                        my_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseInOut]
                    }
                    else if my_options == UIView.AnimationOptions.curveEaseIn
                    {
                        my_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseIn]
                    }
                    else if my_options == UIView.AnimationOptions.curveEaseOut
                    {
                        my_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseOut]
                    }
                    else
                    {
                        my_options = [UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveLinear]
                    }
                }
                
                if my_animationType == SLCWalkerType.spring
                {
                    let damping: CGFloat = 0.85
                    let velocity: CGFloat = 10.0
                    
                    UIView.animate(withDuration: my_animateTime,
                                   delay: my_delay,
                                   usingSpringWithDamping: damping,
                                   initialSpringVelocity: velocity,
                                   options: my_options,
                                   animations: {
                                    
                                    if my_viewWalkerkeyPath == UIViewWalkerKeyFrame
                                    {
                                        if let value = my_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyLeading
                                    {
                                        if let value = my_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyTraing
                                    {
                                        if let value = my_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyTop
                                    {
                                        if let value = my_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyBottom
                                    {
                                        if let value = my_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyWidth
                                    {
                                        if let value = my_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyHeight
                                    {
                                        if let value = my_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeySize
                                    {
                                        if let value = my_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                                    
                    }) { (success) in
                        self.slc_resetInitParams()
                    }
                }
                else
                {
                    UIView.animate(withDuration: my_animateTime,
                                   delay: my_delay,
                                   options: my_options,
                                   animations: {
                                    
                                    if my_viewWalkerkeyPath == UIViewWalkerKeyFrame
                                    {
                                        if let value = my_to
                                        {
                                            self.frame = value as! CGRect
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyLeading
                                    {
                                        if let value = my_to
                                        {
                                            self.leading = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyTraing
                                    {
                                        if let value = my_to
                                        {
                                            self.traing = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyTop
                                    {
                                        if let value = my_to
                                        {
                                            self.top = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyBottom
                                    {
                                        if let value = my_to
                                        {
                                            self.bottom = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyWidth
                                    {
                                        if let value = my_to
                                        {
                                            self.width = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeyHeight
                                    {
                                        if let value = my_to
                                        {
                                            self.height = value as! CGFloat
                                        }
                                    }
                                    else if my_viewWalkerkeyPath == UIViewWalkerKeySize
                                    {
                                        if let value = my_to
                                        {
                                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (value as! CGSize).width, height: (value as! CGSize).height)
                                        }
                                    }
                    }) { (success) in
                        self.slc_resetInitParams()
                    }
                }
            }
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        self.slc_resetInitParams()
    }
    
    private func slc_resetInitParams()
    {
        if let value = self.completion
        {
            value(my_theWalker)
        }
        my_animationType = SLCWalkerType.base
        my_timing = CAMediaTimingFunctionName.linear
        my_options = UIView.AnimationOptions.curveLinear
        my_delay = 0.0
        my_myRepeatCount = 1
        my_reverses = false
        my_animateTime = 0.25
        my_isCAanimation = true
        my_currentKeyPath = SLCWalkerKeyPathPosition
        my_from = nil
        my_to = nil
        my_viewWalkerkeyPath = UIViewWalkerKeyFrame
        my_theWalker = SLCWalker.makePosition
        my_transitionType = SLCWalkerTransitionTypeFade
        my_frameOrigin = CGRect.zero
    }
}
