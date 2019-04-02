//
//  UICollectionView+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum SLCCollectionReload: Int
{
    case visible = 0, fixed
}

private enum SLCCollectionTransition: Int
{
    case  none = 0, content, from
}

private var SLCCollrctionViewCompletionKey: String = "slc.collection.completion"
private var collectionView_animationType: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear
private var collectionView_reload: SLCCollectionReload = SLCCollectionReload.visible
private var collectionView_transition = SLCCollectionTransition.none
private var collectionView_to: CGAffineTransform = CGAffineTransform.identity
private var collectionView_spring: Bool = false
private var collectionView_itemDuration: TimeInterval = 0.7
private var collectionView_itemDelay: TimeInterval = 0.1
private var collectionView_indexPath: IndexPath = IndexPath(item: 0, section: 0)
private var collectionView_transition_to: UIView? = nil
private var collectionView_transitionAnimation: UIView.AnimationOptions = UIView.AnimationOptions.transitionFlipFromLeft
private var collectionView_isHeaderWalker: Bool = false
private var collectionView_isFooterWalker: Bool = false
private var collectionView_totalItemCount: Int = 0


extension UICollectionView
{

    // MARK: -MAKE
    @discardableResult public func c_makeScale(_ scale: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(scaleX: scale, y: scale)
        return self
    }
    
    @discardableResult public func c_makeScaleX(_ scaleX: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(scaleX: scaleX, y: 1.0)
        return self
    }
    
    @discardableResult public func c_makeScaleY(_ scaleY: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(scaleX: 1.0, y: scaleY)
        return self
    }
    
    @discardableResult public func c_makeRotation(_ rotation: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(rotationAngle: rotation)
        return self
    }
    
    @discardableResult public func c_moveX(_ x: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(translationX: x, y: 0)
        return self
    }
    
    @discardableResult public func c_moveY(_ y: CGFloat) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(translationX: 0, y: y)
        return self
    }
    
    @discardableResult public func c_moveXY(_ xy: CGPoint) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_to = CGAffineTransform(translationX: xy.x, y: xy.y)
        return self
    }
    
    @discardableResult public func c_transitionTo(_ to: UIView) -> UICollectionView
    {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.from
        collectionView_transition_to = to
        return self
    }
    
    @discardableResult public func c_itemDuration(_ duration: TimeInterval) -> UICollectionView
    {
        collectionView_itemDuration = duration
        return self
    }
    
    @discardableResult public func c_itemDelay(_ delay: TimeInterval) -> UICollectionView
    {
        collectionView_itemDelay = delay
        return self
    }
    
    @discardableResult public func c_headerWalker(_ walker: Bool) -> UICollectionView
    {
        collectionView_isHeaderWalker = walker
        return self
    }
    
    @discardableResult public func c_footerWalker(_ walker: Bool) -> UICollectionView
    {
        collectionView_isFooterWalker = walker
        return self
    }
    
    public func reloadDataWithWalker()
    {
        collectionView_reload = SLCCollectionReload.visible
        self.slc_startWalker()
    }
    
    public func reloadDataFixedWithDancer(_ indexPath: IndexPath)
    {
        collectionView_reload = SLCCollectionReload.fixed
        collectionView_indexPath = indexPath
        self.slc_startWalker()
    }
    
    public var c_easeLiner: UICollectionView {
        collectionView_animationType = UIView.AnimationOptions.curveLinear
        return self
    }
    
    public var c_easeInOut: UICollectionView {
        collectionView_animationType = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    public var c_easeIn: UICollectionView {
        collectionView_animationType = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    public var c_easeOut: UICollectionView {
        collectionView_animationType = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    
    
    public var c_transitionFlipFromLeft: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    public var c_transitionFlipFromRight: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    public var c_transitionCurlUp: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    public var c_transitionCurlDown: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    public var c_transitionCrossDissolve: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    public var c_transitionFlipFromTop: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    public var c_transitionFlipFromBottom: UICollectionView {
        self.slc_resetInitParams()
        collectionView_transition = SLCCollectionTransition.content
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    public var c_spring: UICollectionView {
        collectionView_spring = true
        return self
    }
    
    
    public var c_completion: SLCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCCollrctionViewCompletionKey) as! SLCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCCollrctionViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    private func slc_resetInitParams()
    {
        collectionView_animationType = UIView.AnimationOptions.curveLinear
        collectionView_reload = SLCCollectionReload.visible
        collectionView_transition = SLCCollectionTransition.none
        collectionView_to = CGAffineTransform.identity;
        collectionView_spring = false
        collectionView_itemDuration = 0.7
        collectionView_itemDelay = 0.1
        collectionView_indexPath = IndexPath(item: 0, section: 0)
        collectionView_transition_to = nil
        collectionView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        collectionView_isHeaderWalker = false
        collectionView_isFooterWalker = false
        collectionView_totalItemCount = 0
    }
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            switch collectionView_reload
            {
              case SLCCollectionReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                let selections: Int = self.numberOfSections
                for index in 0..<selections
                {
                    let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: index))
                    
                    let footer: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: index))
                    
                    let numbers: Int = self.numberOfItems(inSection: index)
                    
                    let delay:TimeInterval = Double(collectionView_totalItemCount) * collectionView_itemDelay
                    
                    if let h = header, collectionView_isHeaderWalker
                    {
                        switch collectionView_transition
                        {
                            
                        case SLCCollectionTransition.none:
                            h.transform = collectionView_to
                            if collectionView_spring
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: collectionView_animationType,
                                               animations: {
                                h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: delay,
                                               options: collectionView_animationType,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case SLCCollectionTransition.content:
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: h,
                                                      duration: collectionView_itemDuration,
                                                      options: collectionView_transitionAnimation,
                                                      animations: nil, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                                        }
                                    })
                            })
                            
                        case SLCCollectionTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: collectionView_transition_to!,
                                                  duration: collectionView_itemDuration,
                                                  options: collectionView_transitionAnimation, completion: { (success) in
                                                    if let c = self.c_completion
                                                    {
                                                        c()
                                                    }
                                })
                            })
                        }
                        
                        collectionView_totalItemCount += 1
                    }
                    
                    
                    for indexRow in 0..<numbers
                    {
                        let cell: UICollectionViewCell? = self.cellForItem(at: IndexPath(item: indexRow, section: index))
                        
                        if let value = cell
                        {
                            switch collectionView_transition
                            {
                                case SLCCollectionTransition.none:
                                value.transform = collectionView_to
                                if collectionView_spring
                                {
                                    UIView.animate(withDuration: collectionView_itemDuration,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: collectionView_animationType,
                                                   animations: {
                                        cell?.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: collectionView_itemDuration,
                                                   delay: collectionView_itemDelay,
                                                   options: collectionView_animationType,
                                                   animations: {
                                        cell?.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                                case SLCCollectionTransition.content:
                                
                                    if let value = cell
                                    {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                            {
                                                UIView.transition(with: value,
                                                                  duration: collectionView_itemDuration,
                                                                  options: collectionView_transitionAnimation,
                                                                  animations: nil,
                                                                  completion: { (success) in
                                                    if let c = self.c_completion
                                                    {
                                                        c()
                                                    }
                                                })
                                        })
                                        
                                    }
                                
                                case SLCCollectionTransition.from:
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                        {
                                            UIView.transition(from: value, to: collectionView_transition_to!, duration: collectionView_itemDuration, options: collectionView_transitionAnimation, completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                                            })
                                    })
                            }
                            
                            collectionView_totalItemCount += 1
                        }
                        
                        if let f = footer, collectionView_isFooterWalker
                        {
                            switch collectionView_transition
                            {
                            case SLCCollectionTransition.none:
                                f.transform = collectionView_to
                                if collectionView_spring
                                {
                                    UIView.animate(withDuration: collectionView_itemDuration,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: collectionView_animationType,
                                                   animations: {
                                        f.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: collectionView_itemDuration,
                                                   delay: delay,
                                                   options: collectionView_animationType,
                                                   animations: {
                                                    f.transform = CGAffineTransform.identity
                                    }, completion: { (success) in
                                        if let c = self.c_completion
                                        {
                                            c()
                                        }
                                    })
                                }
                                
                            case SLCCollectionTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(with: f,
                                                      duration: collectionView_itemDuration,
                                                      options: collectionView_transitionAnimation,
                                                      animations: nil, completion: { (success) in
                                                        if let c = self.c_completion
                                                        {
                                                            c()
                                                        }
                                    })
                                })
                                
                            case SLCCollectionTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                    UIView.transition(from: f,
                                                      to: collectionView_transition_to!,
                                                      duration: collectionView_itemDuration,
                                                      options: collectionView_transitionAnimation,
                                                      completion: { (success) in
                                                        if let c = self.c_completion
                                                        {
                                                            c()
                                                        }
                                    })
                                })
                            }
                        }
                        
                        collectionView_totalItemCount += 1
                    }
                    
                }
            default:
                self.reloadData()
                self.layoutIfNeeded()
                
                let header: UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: collectionView_indexPath)
                
                let footer:UICollectionReusableView? = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: collectionView_indexPath)
                
                let cell: UICollectionViewCell? = self.cellForItem(at: collectionView_indexPath)
                
                if collectionView_isHeaderWalker || collectionView_isFooterWalker
                {
                    if let h = header, collectionView_isHeaderWalker
                    {
                        switch collectionView_transition
                        {
                        case SLCCollectionTransition.none:
                            h.transform = collectionView_to
                            if collectionView_spring
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: collectionView_animationType,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: 0,
                                               options: collectionView_animationType,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { (success) in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                        case SLCCollectionTransition.content:
                            UIView.transition(with: h,
                                              duration: collectionView_itemDuration,
                                              options: collectionView_animationType,
                                              animations: nil,
                                              completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                            
                        case SLCCollectionTransition.from:
                            UIView.transition(from: h,
                                              to: collectionView_transition_to!,
                                              duration: collectionView_itemDuration,
                                              options: collectionView_transitionAnimation,
                                              completion: { (success) in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                        }
                    }
                }
                
                if let f = footer, collectionView_isFooterWalker
                {
                    switch collectionView_transition
                    {
                    case SLCCollectionTransition.none:
                        f.transform = collectionView_to
                        if collectionView_spring
                        {
                            UIView.animate(withDuration: collectionView_itemDuration,
                                           delay: 0,
                                           usingSpringWithDamping: 0.85,
                                           initialSpringVelocity: 10.0,
                                           options: collectionView_animationType,
                                           animations: {
                                            f.transform = CGAffineTransform.identity
                            }, completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                        }
                        else
                        {
                            UIView.animate(withDuration: collectionView_itemDuration,
                                           delay: 0,
                                           options: collectionView_animationType,
                                           animations: {
                                f.transform = CGAffineTransform.identity
                            }, completion: { (success) in
                                if let c = self.c_completion
                                {
                                    c()
                                }
                            })
                        }
                        
                    case SLCCollectionTransition.content:
                        UIView.transition(with: f,
                                          duration: collectionView_itemDuration,
                                          options: collectionView_transitionAnimation,
                                          animations: nil,
                                          completion: { _ in
                                            if let c = self.c_completion
                                            {
                                                c()
                                            }
                        })
                        
                    case SLCCollectionTransition.from:
                        UIView.transition(from: f,
                                          to: collectionView_transition_to!,
                                          duration: collectionView_itemDuration,
                                          options: collectionView_transitionAnimation,
                                          completion: { _ in
                                            if let c = self.c_completion
                                            {
                                                c()
                                            }
                        })
                        
                    }
                }
                else
                {
                    if let cc = cell
                    {
                        switch collectionView_transition
                        {
                        case SLCCollectionTransition.none:
                            cc.transform = collectionView_to
                            if collectionView_spring
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: collectionView_animationType,
                                               animations: {
                                                cc.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: collectionView_itemDuration,
                                               delay: 0,
                                               options: collectionView_animationType,
                                               animations: {
                                                cc.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let c = self.c_completion
                                    {
                                        c()
                                    }
                                })
                            }
                            
                            
                        case SLCCollectionTransition.content:
                            UIView.transition(with: cc,
                                              duration: collectionView_itemDuration,
                                              options: collectionView_transitionAnimation,
                                              animations: nil, completion: { _ in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                            
                        case SLCCollectionTransition.from:
                            UIView.transition(from: cc,
                                              to: collectionView_transition_to!,
                                              duration: collectionView_itemDuration,
                                              options: collectionView_transitionAnimation,
                                              completion: { _ in
                                                if let c = self.c_completion
                                                {
                                                    c()
                                                }
                            })
                            
                        }
                    }
                }
                
                
                break
            }
        }
    }
}
