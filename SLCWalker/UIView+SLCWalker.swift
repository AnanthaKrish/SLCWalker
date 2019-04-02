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

private var view_delay: TimeInterval = 0.0
private var view_repeat: Int = 1
private var view_reverse: Bool = false
private var view_animate: TimeInterval = 0.25

private var view_from: Any? = nil
private var view_to: Any? = nil

private var view_theWalker: SLCWalker = SLCWalker.makePosition
private var view_easeType: SLCViewEasy = SLCViewEasy.easeLiner
private var view_spring: Bool = false
private var view_isTransitionContent: Bool = false
private var view_transitionOptions: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear

public extension UIView
{
    // MARK: MAKE 全部以中心点为依据
    // Function MAKE, based on the center.
    @discardableResult func makeSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeSize
        view_to = size
        return self
    }
    
    @discardableResult func makePosition(_ position: CGPoint) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makePosition
        view_to = position
        return self
    }
    
    @discardableResult func makeX(_ x: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeX
        view_to = x
        return self
    }
    
    @discardableResult func makeY(_ y: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeY
        view_to = y
        return self
    }
    
    @discardableResult func makeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeWidth
        view_to = width
        return self
    }
    
    @discardableResult func makeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeHeight
        view_to = height
        return self
    }
    
    @discardableResult func makeScale(_ scale: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeScale
        view_to = scale
        return self
    }
    
    @discardableResult func makeScaleX(_ scaleX: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeScaleX
        view_to = scaleX
        return self
    }
    
    @discardableResult func makeScaleY(_ scaleY: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeScaleY
        view_to = scaleY
        return self
    }
    
    @discardableResult func makeRotationX(_ rotationX: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeRotationX
        view_to = rotationX
        return self
    }
    
    @discardableResult func makeRotationY(_ rotationY: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeRotationY
        view_to = rotationY
        return self
    }
    
    @discardableResult func makeRotationZ(_ rotationZ: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeRotationZ
        view_to = rotationZ
        return self
    }
    
    @discardableResult func makeBackground(_ background: UIColor) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeBackground
        view_to = background
        return self
    }
    
    @discardableResult func makeOpacity(_ opacity: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeOpacity
        view_to = opacity
        return self
    }
    
    @discardableResult func makeCornerRadius(_ corner: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeCornerRadius
        view_to = corner
        return self
    }
    
    @discardableResult func makeStorkeEnd(_ storkeEnd: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeStrokeEnd
        view_to = storkeEnd
        return self
    }
    
    @discardableResult func makeContent(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeContent
        view_from = from
        view_to = to
        return self
    }
    
    @discardableResult func makeBorderWidth(_ borderWidth: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeBorderWidth
        view_to = borderWidth
        return self
    }
    
    @discardableResult func makeShadowColor(_ shadowColor: UIColor) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeShadowColor
        view_to = shadowColor
        return self
    }
    
    @discardableResult func makeShadowOffset(_ shadowOffset: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeShadowOffset
        view_to = shadowOffset
        return self
    }
    
    @discardableResult func makeShadowOpacity(_ shadowOpacity: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeShadowOpacity
        view_to = shadowOpacity
        return self
    }
    
    @discardableResult func makeShadowRadius(_ shadowRadius: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.makeShadowRadius
        view_to = shadowRadius
        return self
    }
    
    
    
    
    
    
    // MARK: TAKE 全部以边界点为依据 (repeat无效)
    // Function TAKE, based on the boundary (parameter repeat is unavailable).
    @discardableResult func takeFrame(_ rect: CGRect) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeFrame
        view_to = rect
        return self
    }
    
    @discardableResult func takeLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeLeading
        view_to = leading
        return self
    }
    
    @discardableResult func takeTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeTraing
        view_to = traing
        return self
    }
    
    @discardableResult func takeTop(_ top: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeTop
        view_to = top
        return self
    }
    
    @discardableResult func takeBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeBottom
        view_to = bottom
        return self
    }
    
    @discardableResult func takeWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeWidth
        view_to = width
        return self
    }
    
    @discardableResult func takeHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeHeight
        view_to = height
        return self
    }
    
    @discardableResult func takeSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.takeSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: MOVE 相对移动 (以中心点为依据)
    // Function MOVE , relative movement (based on the center).
    @discardableResult func moveX(_ x: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveX
        view_to = x
        return self
    }
    
    @discardableResult func moveY(_ y: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveY
        view_to = y
        return self
    }
    
    @discardableResult func moveXY(_ xy: CGPoint) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveXY
        view_to = xy
        return self
    }
    
    @discardableResult func moveWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveWidth
        view_to = width
        return self
    }
    
    @discardableResult func moveHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveHeight
        view_to = height
        return self
    }
    
    @discardableResult func moveSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.moveSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    
    // MARK: ADD 相对移动(以边界为依据) (repeat无效)
    // Function ADD , relative movement (based on the boundary). (parameter repeat is unavailable).
    @discardableResult func addLeading(_ leading: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addLeading
        view_to = leading
        return self
    }
    
    @discardableResult func addTraing(_ traing: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addTraing
        view_to = traing
        return self
    }
    
    @discardableResult func addTop(_ top: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addTop
        view_to = top
        return self
    }
    
    @discardableResult func addBottom(_ bottom: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addBottom
        view_to = bottom
        return self
    }
    
    @discardableResult func addWidth(_ width: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addWidth
        view_to = width
        return self
    }
    
    @discardableResult func addHeight(_ height: CGFloat) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addHeight
        view_to = height
        return self
    }
    
    @discardableResult func addSize(_ size: CGSize) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.addSize
        view_to = size
        return self
    }
    
    
    
    
    
    
    // MARK: TRANSITION 转场动画
    // Transition animation
    @discardableResult func transitionDir(_ dir: SLCWalkerTransitionDirection) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.transition
        view_to = dir
        return self
    }
    
    @discardableResult func transitionFrom(_ from: Any, _ to: Any) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.transition
        view_from = from
        view_to = to
        view_isTransitionContent = true
        return self
    }
    
    
    
    
    
    // MARK: PATH 轨迹动画
    // Path animation
    @discardableResult func path(_ apath: UIBezierPath) -> UIView
    {
        self.slc_resetInitParams()
        view_theWalker = SLCWalker.path
        view_to = apath
        return self
    }
    
    
    
    
    
    
    
    
    // MARK: 通用属性
    // Content, general propertys
    @discardableResult func delay(_ adelay: TimeInterval) -> UIView
    {
        view_delay = adelay
        return self
    }
    
    // 注: repeat对TAKE和ADD无效
    // NOTE: repeat is unavailable for TAKE and ADD
    @discardableResult func repeatNumber(_ re: Int) -> UIView
    {
        view_repeat = re
        return self
    }
    
    @discardableResult func reverses(_ isrecerses: Bool) -> UIView
    {
        view_reverse = isrecerses
        return self
    }
    
    @discardableResult func animate(_ duration: TimeInterval) -> UIView
    {
        view_animate = duration
        self.slc_startWalker()
        return self
    }
    
    
    var completion: SLCWalkerCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCWalkerViewCompletionKey) as! SLCWalkerCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCWalkerViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    
    // MARK: 动画样式
    // animated style
    var easeInOut: UIView {
        view_easeType = SLCViewEasy.easeInOut
        view_transitionOptions = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var easeIn: UIView {
        view_easeType = SLCViewEasy.easeIn
        view_transitionOptions = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var easeOut: UIView {
        view_easeType = SLCViewEasy.easeOut
        view_transitionOptions = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var easeLiner: UIView {
        view_easeType = SLCViewEasy.easeLiner
        view_transitionOptions = UIView.AnimationOptions.curveLinear
        return self
    }
    
    
    
    
    
    // MARK: 弹性
    // bounce
    var spring: UIView {
        view_spring = true
        return self
    }
    
    
    
    
    // MARK: 转场动画样式 (只适用于TRANSITION, spring无效. 其他通过layer去操作)
    // Transition animation style (only for TRANSITION, spring is unavailable, Others operate through the layer)
    var transitionFlipFromLeft: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionFlipFromLeft
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromRight: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionFlipFromRight
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCurlUp: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionCurlUp
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCurlDown: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionCurlDown
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionCrossDissolve: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionCrossDissolve
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromTop: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionFlipFromTop
        view_theWalker = SLCWalker.transition
        return self
    }
    
    var transitionFlipFromBottom: UIView {
        view_transitionOptions = UIView.AnimationOptions.transitionFlipFromBottom
        view_theWalker = SLCWalker.transition
        return self
    }
    
    
    
    // MARK: 关联动画,then以后前一个完成后才完成第二个
    //Associated animation, after the previous one is completed, then the second animate.
    var then: UIView {
        view_delay = view_animate
        return self
    }
    
    
    func removeWalkers()
    {
        self.layer.removeWalkers()
    }
    
    func reloadWalker()
    {
        self.layer.reloadWalker()
    }
    
    
    
    
    
    private func slc_resetInitParams()
    {
        view_delay = 0.0
        view_repeat = 1
        view_reverse = false
        view_animate = 0.25
        
        view_from = nil
        view_to = nil
        view_theWalker = SLCWalker.makePosition
        view_easeType = SLCViewEasy.easeLiner
        view_spring = false
        view_isTransitionContent = false
        view_transitionOptions = UIView.AnimationOptions.curveLinear
    }
    
    private func slc_startWalker()
    {
        switch view_theWalker
        {
        case SLCWalker.makeSize:
        
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
         
        case SLCWalker.makePosition:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        case SLCWalker.makeX:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.makeY:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
           
        case SLCWalker.makeWidth:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.makeHeight:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeScale:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeScaleX:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        case SLCWalker.makeScaleY:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.makeRotationX:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeRotationY:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeRotationZ:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
         
        case SLCWalker.makeBackground:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.makeOpacity:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeCornerRadius:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
         
            
            
        case SLCWalker.makeStrokeEnd:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
         
            
            
        case SLCWalker.makeContent:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
         
            
        case SLCWalker.makeBorderWidth:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
          
            
        case SLCWalker.makeShadowColor:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeShadowOffset:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.makeShadowOpacity:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.makeShadowRadius:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeFrame:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
           
        case SLCWalker.takeLeading:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeTraing:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeTop:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        case SLCWalker.takeBottom:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeWidth:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeHeight:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.takeSize:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.moveX:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.moveY:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.moveXY:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.moveWidth:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.moveHeight:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.moveSize:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.addLeading:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.addTraing:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.addTop:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.addBottom:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
            
        case SLCWalker.addWidth:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.addHeight:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
            
        case SLCWalker.addSize:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
            
        
        case SLCWalker.transition:
            
            if view_reverse
            {
                if view_transitionOptions == UIView.AnimationOptions.transitionFlipFromLeft
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionFlipFromLeft, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionFlipFromRight
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionFlipFromRight, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionFlipFromTop
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionFlipFromTop, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionFlipFromBottom
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionFlipFromBottom, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionCurlUp
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionCurlUp, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionCurlDown
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionCurlDown, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
                else if view_transitionOptions == UIView.AnimationOptions.transitionCrossDissolve
                {
                    view_transitionOptions = [UIView.AnimationOptions.transitionCrossDissolve, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
            {
                if view_isTransitionContent
                {
                    UIView.transition(from: self,
                                      to: view_to as! UIView,
                                      duration: view_animate,
                                      options: view_transitionOptions,
                                      completion: { (success) in
                        view_isTransitionContent = false
                        if let value = self.completion
                        {
                            value(SLCWalker.transition)
                        }
                    })
                }
                else
                {
                    UIView.transition(with: self,
                                      duration: view_animate,
                                      options: view_transitionOptions,
                                      animations: nil,
                                      completion: { (success) in
                                        view_isTransitionContent = false
                                        if let value = self.completion
                                        {
                                            value(SLCWalker.transition)
                                        }
                    })
                }
            }
            
        case SLCWalker.path:
            
            if view_easeType == SLCViewEasy.easeInOut
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
            else if view_easeType == SLCViewEasy.easeIn
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
            else if view_easeType == SLCViewEasy.easeOut
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
            else if view_easeType == SLCViewEasy.easeLiner
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
