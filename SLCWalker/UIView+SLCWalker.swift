//
//  UIView+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/3/27.
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

private var SLCWalkerViewCompletionKey: String = "slc.view.completion"

private enum SLCViewEasy: Int
{
    case easeInOut = 0, easeIn, easeOut, easeLiner
}

private enum SLCViewWalkerTransition: Int
{
    case fade = 0, push, reveal, moveIn, cube, suck, ripple, curl, unCurl,
    flip, hollowOpen, hollowClose
}

private var view_delay: TimeInterval = 0.0
private var view_repeat: Int = 1
private var view_reverse: Bool = false
private var view_animate: TimeInterval = 0.25

private var view_from: Any? = nil
private var view_to: Any? = nil

private var view_theWalker: SLCWalker = .makePosition
private var view_easeType: SLCViewEasy = .easeLiner
private var view_spring: Bool = false
private var view_transitionType: SLCViewWalkerTransition = .fade
private var view_isTransitionContent: Bool = false
private var view_transitionOptions: UIView.AnimationOptions = .curveLinear

public extension UIView
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
    @discardableResult public func makeSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeSize
        view_to = size
        return self
    }
    
    @discardableResult public func makePosition(_ position: CGPoint) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makePosition
        view_to = position
        return self
    }
    
    @discardableResult public func makeX(_ x: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeX
        view_to = x
        return self
    }
    
    @discardableResult public func makeY(_ y: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeY
        view_to = y
        return self
    }
    
    @discardableResult public func makeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeWidth
        view_to = width
        return self
    }
    
    @discardableResult public func makeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeHeight
        view_to = height
        return self
    }
    
    @discardableResult public func makeScale(_ scale: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeScale
        view_to = scale
        return self
    }
    
    @discardableResult public func makeScaleX(_ scaleX: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeScaleX
        view_to = scaleX
        return self
    }
    
    @discardableResult public func makeScaleY(_ scaleY: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeScaleY
        view_to = scaleY
        return self
    }
    
    @discardableResult public func makeRotationX(_ rotationX: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeRotationX
        view_to = rotationX
        return self
    }
    
    @discardableResult public func makeRotationY(_ rotationY: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeRotationY
        view_to = rotationY
        return self
    }
    
    @discardableResult public func makeRotationZ(_ rotationZ: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeRotationZ
        view_to = rotationZ
        return self
    }
    
    @discardableResult public func makeBackground(_ background: UIColor) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeBackground
        view_to = background
        return self
    }
    
    @discardableResult public func makeOpacity(_ opacity: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeOpacity
        view_to = opacity
        return self
    }
    
    @discardableResult public func makeCornerRadius(_ corner: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeCornerRadius
        view_to = corner
        return self
    }
    
    @discardableResult public func makeStorkeEnd(_ storkeEnd: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeStrokeEnd
        view_to = storkeEnd
        return self
    }
    
    @discardableResult public func makeContent(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeContent
        view_from = from
        view_to = to
        return self
    }
    
    @discardableResult public func makeBorderWidth(_ borderWidth: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeBorderWidth
        view_to = borderWidth
        return self
    }
    
    @discardableResult public func makeShadowColor(_ shadowColor: UIColor) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeShadowColor
        view_to = shadowColor
        return self
    }
    
    @discardableResult public func makeShadowOffset(_ shadowOffset: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeShadowOffset
        view_to = shadowOffset
        return self
    }
    
    @discardableResult public func makeShadowOpacity(_ shadowOpacity: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeShadowOpacity
        view_to = shadowOpacity
        return self
    }
    
    @discardableResult public func makeShadowRadius(_ shadowRadius: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .makeShadowRadius
        view_to = shadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult public func takeFrame(_ rect: CGRect) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeFrame
        view_to = rect
        return self
    }
    
    @discardableResult public func takeLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeLeading
        view_to = leading
        return self
    }
    
    @discardableResult public func takeTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeTraing
        view_to = traing
        return self
    }
    
    @discardableResult public func takeTop(_ top: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeTop
        view_to = top
        return self
    }
    
    @discardableResult public func takeBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeBottom
        view_to = bottom
        return self
    }
    
    @discardableResult public func takeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeWidth
        view_to = width
        return self
    }
    
    @discardableResult public func takeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeHeight
        view_to = height
        return self
    }
    
    @discardableResult public func takeSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .takeSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult public func moveX(_ x: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveX
        view_to = x
        return self
    }
    
    @discardableResult public func moveY(_ y: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveY
        view_to = y
        return self
    }
    
    @discardableResult public func moveXY(_ xy: CGPoint) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveXY
        view_to = xy
        return self
    }
    
    @discardableResult public func moveWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveWidth
        view_to = width
        return self
    }
    
    @discardableResult public func moveHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveHeight
        view_to = height
        return self
    }
    
    @discardableResult public func moveSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .moveSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult public func addLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addLeading
        view_to = leading
        return self
    }
    
    @discardableResult public func addTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addTraing
        view_to = traing
        return self
    }
    
    @discardableResult public func addTop(_ top: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addTop
        view_to = top
        return self
    }
    
    @discardableResult public func addBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addBottom
        view_to = bottom
        return self
    }
    
    @discardableResult public func addWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addWidth
        view_to = width
        return self
    }
    
    @discardableResult public func addHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addHeight
        view_to = height
        return self
    }
    
    @discardableResult public func addSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .addSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult public func transitionDir(_ dir: SLCWalkerTransitionDirection) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .transition
        view_to = dir
        return self
    }
    
    @discardableResult public func transitionFrom(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .transition
        view_from = from
        view_to = to
        view_isTransitionContent = true
        return self
    }
    
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult public func path(_ apath: UIBezierPath) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = .path
        view_to = apath
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult public func delay(_ adelay: TimeInterval) -> UIView
    {
        view_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult public func repeatNumber(_ re: Int) -> UIView
    {
        view_repeat = re
        return self
    }
    
    @discardableResult public func reverses(_ isrecerses: Bool) -> UIView
    {
        view_reverse = isrecerses
        return self
    }
    
    @discardableResult public func animate(_ duration: TimeInterval) -> UIView
    {
        view_animate = duration
        self.slc_startWalker()
        return self
    }
    
    
    public var completion: SLCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewCompletionKey) as! SLCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    
    // MARK: 动画样式
    // animated style
    public var easeInOut: UIView {
        view_easeType = .easeInOut
        view_transitionOptions = .curveEaseInOut
        return self
    }
    
    public var easeIn: UIView {
        view_easeType = .easeIn
        view_transitionOptions = .curveEaseIn
        return self
    }
    
    public var easeOut: UIView {
        view_easeType = .easeOut
        view_transitionOptions = .curveEaseOut
        return self
    }
    
    public var easeLiner: UIView {
        view_easeType = .easeLiner
        view_transitionOptions = .curveLinear
        return self
    }
    
    
    
    
    
    // MARK: 弹性
    // bounce
    public var spring: UIView {
        view_spring = true
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效. transitionFrom时只有Curl和UnCurl有效)
    // Transition animation style (only for TRANSITION, spring is unavailable, Only Curl and UnCurl are valid when transitionFrom)
    public var transitionFade: UIView {
        view_transitionType = .fade
        return self
    }
    
    public var transitionPush: UIView {
        view_transitionType = .push
        return self
    }
    
    public var transitionReveal: UIView {
        view_transitionType = .reveal
        return self
    }
    
    public var transitionMoveIn: UIView {
        view_transitionType = .moveIn
        return self
    }
    
    public var transitionCube: UIView {
        view_transitionType = .cube
        return self
    }
    
    public var transitionSuck: UIView {
        view_transitionType = .suck
        return self
    }
    
    public var transitionRipple: UIView {
        view_transitionType = .ripple
        return self
    }
    
    public var transitionCurl: UIView {
        view_transitionType = .curl
        view_transitionOptions = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    public var transitionUnCurl: UIView {
        view_transitionType = .unCurl
        view_transitionOptions = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    public var transitionFlip: UIView {
        view_transitionType = .flip
        return self
    }
    
    public var transitionHollowOpen: UIView {
        view_transitionType = .hollowOpen
        return self
    }
    
    public var transitionHollowClose: UIView {
        view_transitionType = .hollowClose
        return self
    }
    
    
    
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    public var then: UIView {
        view_delay = view_animate
        return self
    }
    
    
    public func removeWalkers()
    {
        self.layer.removeWalkers()
    }
    
    
    
    
    
    private func slc_resetInitParams()
    {
        view_delay = 0.0
        view_repeat = 1
        view_reverse = false
        view_animate = 0.25
        
        view_from = nil
        view_to = nil
        view_theWalker = .makePosition
        view_easeType = .easeLiner
        view_spring = false
        view_transitionType = .fade
        view_isTransitionContent = false
        view_transitionOptions = .curveLinear
    }
    
    private func slc_startWalker()
    {
        switch view_theWalker
        {
        case .makeSize:
        
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeSize(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
        case .makePosition:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makePosition(value as! CGPoint).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case .makeX:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .makeY:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
           
        case .makeWidth:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .makeHeight:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeHeight(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeScale:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScale(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeScaleX:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case .makeScaleY:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeScaleY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .makeRotationX:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeRotationY:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeRotationZ:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeRotationZ(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
         
        case .makeBackground:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBackground(value as! UIColor).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .makeOpacity:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeOpacity(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeCornerRadius:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeCornerRadius(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case .makeStrokeEnd:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeStorkeEnd(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
            
        case .makeContent:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to, let value2 = view_from
                    {
                        self.layer.makeContent(value2, value).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
         
            
        case .makeBorderWidth:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeBorderWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
          
            
        case .makeShadowColor:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowColor(value as! UIColor).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeShadowOffset:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOffset(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .makeShadowOpacity:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowOpacity(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .makeShadowRadius:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.makeShadowRadius(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeFrame:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeFrame(value as! CGRect).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
           
        case .takeLeading:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeLeading(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeTraing:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTraing(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeTop:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeTop(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        case .takeBottom:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeBottom(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeWidth:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeWidth(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeHeight:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeHeight(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .takeSize:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.takeSize(value as! CGSize).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .moveX:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveX(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .moveY:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveY(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .moveXY:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveXY(value as! CGPoint).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .moveWidth:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveWidth(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .moveHeight:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveHeight(value as! CGFloat).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .moveSize:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.moveSize(value as! CGSize).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .addLeading:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addLeading(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .addTraing:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTraing(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .addTop:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addTop(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .addBottom:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addBottom(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
            
        case .addWidth:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addWidth(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .addHeight:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addHeight(value as! CGFloat).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
            
        case .addSize:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeInOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeIn.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeOut.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(view_delay).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.addSize(value as! CGSize).easeLiner.delay(view_delay).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        
        case .transition:
            
            if view_isTransitionContent
            {
                if view_reverse
                {
                    if view_transitionOptions == .curveLinear
                    {
                        view_transitionOptions = [.curveLinear, .autoreverse, .repeat];
                    }
                    else if view_transitionOptions == .curveEaseInOut
                    {
                        view_transitionOptions = [.curveEaseInOut, .autoreverse, .repeat];
                    }
                    else if view_transitionOptions == .curveEaseIn
                    {
                        view_transitionOptions = [.curveEaseIn, .autoreverse, .repeat];
                    }
                    else if view_transitionOptions == .curveEaseOut
                    {
                        view_transitionOptions = [.curveEaseOut, .autoreverse, .repeat];
                    }
                    else if view_transitionOptions == .transitionCurlUp
                    {
                        view_transitionOptions = [.transitionCurlUp, .autoreverse, .repeat];
                    }
                    else if view_transitionOptions == .transitionCurlDown
                    {
                        view_transitionOptions = [.transitionCurlDown, .autoreverse, .repeat];
                    }
                }
                
                if let value1 = view_from, let value2 = view_to
                {
                    UIView.transition(from: value1 as! UIView,
                                      to: value2 as! UIView,
                                      duration: view_animate,
                                      options: view_transitionOptions) { (success) in
                        
                                        view_isTransitionContent = false
                                        if let va = self.completion
                                        {
                                            va(SLCWalker.transition)
                                        }
                    }
                }
            }
            else
            {
                if view_easeType == .easeLiner
                {
                    switch view_transitionType
                    {
                    case .fade:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFade.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .push:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionPush.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                        
                    case .reveal:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionReveal.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .moveIn:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionMoveIn.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .cube:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCube.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .suck:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionSuck.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .ripple:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionRipple.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .curl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .unCurl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionUnCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .flip:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFlip.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowOpen:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowOpen.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowClose:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeLiner.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowClose.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                    }
                }
                else if view_easeType == .easeIn
                {
                    switch view_transitionType
                    {
                    case .fade:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFade.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .push:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionPush.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                        
                    case .reveal:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionReveal.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .moveIn:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionMoveIn.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .cube:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCube.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .suck:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionSuck.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .ripple:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionRipple.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .curl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .unCurl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionUnCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .flip:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFlip.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowOpen:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowOpen.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowClose:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeIn.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowClose.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                    }
                }
                else if view_easeType == .easeOut
                {
                    switch view_transitionType
                    {
                    case .fade:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFade.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .push:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionPush.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                        
                    case .reveal:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionReveal.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .moveIn:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionMoveIn.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .cube:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCube.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .suck:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionSuck.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .ripple:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionRipple.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .curl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .unCurl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionUnCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .flip:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFlip.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowOpen:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowOpen.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowClose:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowClose.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                    }
                }
                else if view_easeType == .easeInOut
                {
                    switch view_transitionType
                    {
                    case .fade:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFade.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .push:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionPush.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                        
                    case .reveal:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionReveal.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .moveIn:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionMoveIn.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .cube:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCube.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .suck:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionSuck.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .ripple:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionRipple.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .curl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .unCurl:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionUnCurl.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .flip:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionFlip.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowOpen:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowOpen.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                        
                    case .hollowClose:
                        
                        if let value = view_to
                        {
                            self.layer.transitionDir(value as! SLCWalkerTransitionDirection).easeInOut.repeatNumber(view_repeat).reverses(view_reverse).delay(view_delay).transitionHollowClose.animate(view_animate).completion = { atype in
                                
                                if self.completion != nil
                                {
                                    self.completion!(atype)
                                }
                            }
                        }
                    }
                }
            }
            
            
        case .path:
            
            if view_easeType == .easeInOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeInOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeIn
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeIn.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeOut
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeOut.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            else if view_easeType == .easeLiner
            {
                if view_spring
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).spring.animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
                else
                {
                    if let value = view_to
                    {
                        self.layer.path(value as! UIBezierPath).easeLiner.delay(view_delay).repeatNumber(view_repeat).reverses(view_reverse).animate(view_animate).completion = { atype in
                            
                            if self.completion != nil
                            {
                                self.completion!(atype)
                            }
                        }
                    }
                }
            }
            
        }
    }
}