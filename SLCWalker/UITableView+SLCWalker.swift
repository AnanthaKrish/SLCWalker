//
//  UITableView+SLCWalker.swift
//  SLCWalker
//
//  Created by WeiKunChao on 2019/4/1.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private enum SLCTableViewReload: Int
{
    case visible = 0, fixed
}

private enum SLCTableViewTransition: Int
{
    case none = 0, content, from
}

private var SLCTableViewCompletionKey: String = "slc.tableView.completion"
private var tableView_animationType: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear
private var tableView_reload: SLCTableViewReload = SLCTableViewReload.visible
private var tableView_transition: SLCTableViewTransition = SLCTableViewTransition.none
private var tableView_to: CGAffineTransform = CGAffineTransform.identity
private var tableView_sprinh: Bool = false
private var tableView_itemDuration: TimeInterval = 0.7
private var tableView_itemDelay: TimeInterval = 0.1
private var tableView_indexPath: IndexPath = IndexPath(row: 0, section: 0)
private var tableView_transition_to: UIView? = nil
private var tableView_transitionAnimation: UIView.AnimationOptions = UIView.AnimationOptions.transitionFlipFromLeft
private var tableView_isHeaderWalker: Bool = false
private var tableView_isFooterWalker: Bool = false
private var tableView_totalItemsCount: Int = 0

public extension UITableView
{
    @discardableResult func t_makeScale(_ scale: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(scaleX: scale, y: scale)
        return self
    }
    
    @discardableResult func t_makeScaleX(_ scaleX: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(scaleX: scaleX, y: 1.0)
        return self
    }
    
    @discardableResult func t_makeScaleY(_ scaleY: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(scaleX: 1.0, y: scaleY)
        return self
    }
    
    @discardableResult func t_makeRotation(_ rotation: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(rotationAngle: rotation)
        return self
    }
    
    
    
    @discardableResult func t_moveX(_ x: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(translationX: x, y: 0)
        return self
    }
    
    @discardableResult func t_moveY(_ y: CGFloat) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(translationX: 0, y: y)
        return self
    }
    
    @discardableResult func t_moveXY(_ xy: CGPoint) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_to = CGAffineTransform(translationX: xy.x, y: xy.y)
        return self
    }
    
    
    
    
    @discardableResult func t_transitionTo(_ to: UIView) -> UITableView
    {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.from
        tableView_transition_to = to
        return self
    }
    
    @discardableResult func t_itemDuration(_ duration: TimeInterval) -> UITableView
    {
        tableView_itemDuration = duration
        return self
    }
    
    @discardableResult func t_itemDelay(_ delay: TimeInterval) -> UITableView
    {
        tableView_itemDelay = delay
        return self
    }
    
    
    @discardableResult func headerWalker(_ walker: Bool) -> UITableView
    {
        tableView_isHeaderWalker = walker
        return self
    }
    
    @discardableResult func footerWalker(_ walker: Bool) -> UITableView
    {
        tableView_isFooterWalker = walker
        return self
    }
    
    
    func reloadDataWithWalker()
    {
        tableView_reload = SLCTableViewReload.visible
        self.slc_startWalker()
    }
    
    func reloadDataFixedWithWalker(_ indexPath: IndexPath)
    {
        tableView_reload = SLCTableViewReload.fixed
        tableView_indexPath = indexPath
        self.slc_startWalker()
    }
    
    
    
    
    
    var t_easeLiner: UITableView {
        tableView_animationType = UIView.AnimationOptions.curveLinear
        return self
    }
    
    var t_easeInOut: UITableView {
        tableView_animationType = UIView.AnimationOptions.curveEaseInOut
        return self
    }
    
    var t_easeIn: UITableView {
        tableView_animationType = UIView.AnimationOptions.curveEaseIn
        return self
    }
    
    var t_easeOut: UITableView {
        tableView_animationType = UIView.AnimationOptions.curveEaseOut
        return self
    }
    
    var t_transitionFlipFromLeft: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        return self
    }
    
    var t_transitionFlipFromRight: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromRight
        return self
    }
    
    var t_transitionCurlUp: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlUp
        return self
    }
    
    var t_transitionCurDown: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionCurlDown
        return self
    }
    
    var t_transitionCrossDissolve: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionCrossDissolve
        return self
    }
    
    var t_transitionFlipFromTop: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromTop
        return self
    }
    
    var t_transitionFlipFromBottom: UITableView {
        self.slc_resetInitParams()
        tableView_transition = SLCTableViewTransition.content
        tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromBottom
        return self
    }
    
    var t_spring: UITableView {
        tableView_sprinh = true
        return self
    }
    
    var t_completion: SLCWalkerVoidCompletion {
        get {
            return objc_getAssociatedObject(self, &SLCTableViewCompletionKey) as! SLCWalkerVoidCompletion
        }
        set {
            objc_setAssociatedObject(self, &SLCTableViewCompletionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    
    
    
    
    private func slc_resetInitParams()
    {
        tableView_animationType = UIView.AnimationOptions.curveLinear
        tableView_reload = SLCTableViewReload.visible
        tableView_transition = SLCTableViewTransition.none
        tableView_to = CGAffineTransform.identity
        tableView_sprinh = false
        tableView_itemDuration = 0.7
        tableView_itemDelay = 0.1
        tableView_indexPath = IndexPath(row: 0, section: 0)
        tableView_transition_to = nil
        tableView_transitionAnimation = UIView.AnimationOptions.transitionFlipFromLeft
        tableView_isHeaderWalker = false
        tableView_isFooterWalker = false
        tableView_totalItemsCount = 0
    }
    
    
    private func slc_startWalker()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01)
        {
            switch tableView_reload
            {
            case SLCTableViewReload.visible:
                self.reloadData()
                self.layoutIfNeeded()
                
                let sections: Int = self.numberOfSections
                
                for index in 0..<sections
                {
                    let header: UITableViewHeaderFooterView? = self.headerView(forSection: index)
                    let footer: UITableViewHeaderFooterView? = self.footerView(forSection: index)
                    
                    let numbers: Int = self.numberOfRows(inSection: index)
                    
                    let delay: TimeInterval = Double(tableView_totalItemsCount) * tableView_itemDelay
                    
                    if let h = header, tableView_isHeaderWalker
                    {
                        switch tableView_transition
                        {
                        case SLCTableViewTransition.none:
                            h.transform = tableView_to
                            if tableView_sprinh
                            {
                             UIView.animate(withDuration: tableView_itemDuration,
                                            delay: delay,
                                            usingSpringWithDamping: 0.85,
                                            initialSpringVelocity: 10.0,
                                            options: tableView_animationType,
                                            animations: {
                                                h.transform = CGAffineTransform.identity
                             },
                                            completion: { _ in
                                               if let t = self.t_completion
                                               {
                                                t()
                                                }
                             })
                            }
                            else
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: delay,
                                               options: tableView_animationType,
                                               animations: {
                                    h.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(with: h,
                                                  duration: tableView_itemDuration,
                                                  options: tableView_transitionAnimation,
                                                  animations: nil,
                                                  completion: { _ in
                                                    if let t = self.t_completion
                                                    {
                                                        t()
                                                    }
                                })
                            })
                            
                            
                        case SLCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                UIView.transition(from: h,
                                                  to: tableView_transition_to!,
                                                  duration: tableView_itemDuration,
                                                  options: tableView_transitionAnimation,
                                                  completion: { _ in
                                                    if let t = self.t_completion
                                                    {
                                                        t()
                                                    }
                                })
                            })
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                    
                    for indexRow in 0..<numbers
                    {
                        let cell: UITableViewCell? = self.cellForRow(at: IndexPath(row: indexRow, section: index))
                        if let c = cell
                        {
                            switch tableView_transition
                            {
                            case SLCTableViewTransition.none:
                                c.transform = tableView_to
                                if tableView_sprinh
                                {
                                    UIView.animate(withDuration: tableView_itemDuration,
                                                   delay: delay,
                                                   usingSpringWithDamping: 0.85,
                                                   initialSpringVelocity: 10.0,
                                                   options: tableView_animationType,
                                                   animations: {
                                                    c.transform = CGAffineTransform.identity
                                    }, completion: { _ in
                                        if let t = self.t_completion
                                        {
                                            t()
                                        }
                                    })
                                }
                                else
                                {
                                    UIView.animate(withDuration: tableView_itemDuration,
                                                   delay: delay,
                                                   options: tableView_animationType,
                                                   animations: {
                                                    c.transform = CGAffineTransform.identity
                                    }, completion: { _ in
                                        if let t = self.t_completion
                                        {
                                            t()
                                        }
                                    })
                                }
                                
                            case SLCTableViewTransition.content:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(with: c,
                                                          duration: tableView_itemDuration,
                                                          options: tableView_transitionAnimation,
                                                          animations: nil,
                                                          completion: { _ in
                                                            if let t = self.t_completion
                                                            {
                                                                t()
                                                            }
                                        })
                                })
                                
                            case SLCTableViewTransition.from:
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                    {
                                        UIView.transition(from: c,
                                                          to: tableView_transition_to!,
                                                          duration: tableView_itemDuration,
                                                          options: tableView_transitionAnimation,
                                                          completion: { _ in
                                                            if let t = self.t_completion
                                                            {
                                                                t()
                                                            }
                                        })
                                })
                            }
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                    
                    
                    if let f = footer, tableView_isFooterWalker
                    {
                        switch tableView_transition
                        {
                        case SLCTableViewTransition.none:
                            f.transform = tableView_to
                            if tableView_sprinh
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: delay,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: tableView_animationType,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: delay,
                                               options: tableView_animationType,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(with: f,
                                                      duration: tableView_itemDuration,
                                                      options: tableView_transitionAnimation,
                                                      animations: nil,
                                                      completion: { _ in
                                                        if let t = self.t_completion
                                                        {
                                                            t()
                                                        }
                                    })
                            })
                            
                            
                        case SLCTableViewTransition.from:
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute:
                                {
                                    UIView.transition(from: f,
                                                      to: tableView_transition_to!,
                                                      duration: tableView_itemDuration,
                                                      options: tableView_transitionAnimation,
                                                      completion: { _ in
                                                        if let t = self.t_completion
                                                        {
                                                            t()
                                                        }
                                    })
                            })
                        }
                        
                        tableView_totalItemsCount += 1
                    }
                }
                
                
            case SLCTableViewReload.fixed:
                self.reloadData()
                self.layoutIfNeeded()
                
                let header: UITableViewHeaderFooterView? = self.headerView(forSection: tableView_indexPath.section)
                let footer: UITableViewHeaderFooterView? = self.footerView(forSection: tableView_indexPath.section)
                let item: UITableViewCell? = self.cellForRow(at: tableView_indexPath)
                
                if tableView_isFooterWalker || tableView_isHeaderWalker
                {
                    if let h = header, tableView_isHeaderWalker
                    {
                        switch tableView_transition
                        {
                        case SLCTableViewTransition.none:
                            h.transform = tableView_to
                            if tableView_sprinh
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: tableView_animationType,
                                               animations: {
                                                h.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               options: tableView_animationType,
                                               animations: {
                                                h.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: h,
                                              duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: h,
                                              to: tableView_transition_to!, duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                    
                    if let f = footer, tableView_isFooterWalker
                    {
                        switch tableView_transition
                        {
                        case SLCTableViewTransition.none:
                            f.transform = tableView_to
                            if tableView_sprinh
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: tableView_animationType,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                }, completion: { _ in
                                    if let t = self.t_completion
                                    {
                                        t()
                                    }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               options: tableView_animationType,
                                               animations: {
                                                f.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: f,
                                              duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              animations: nil,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: f,
                                              to: tableView_transition_to!, duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                }
                else
                {
                    if let i = item
                    {
                        switch tableView_transition
                        {
                        case SLCTableViewTransition.none:
                            i.transform = CGAffineTransform.identity
                            if tableView_sprinh
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               usingSpringWithDamping: 0.85,
                                               initialSpringVelocity: 10.0,
                                               options: tableView_animationType,
                                               animations: {
                                                i.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            else
                            {
                                UIView.animate(withDuration: tableView_itemDuration,
                                               delay: 0,
                                               options: tableView_animationType,
                                               animations: {
                                                i.transform = CGAffineTransform.identity
                                },
                                               completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                                })
                            }
                            
                        case SLCTableViewTransition.content:
                            UIView.transition(with: i,
                                              duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              animations: nil, completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                            
                        case SLCTableViewTransition.from:
                            UIView.transition(from: i,
                                              to: tableView_transition_to!,
                                              duration: tableView_itemDuration,
                                              options: tableView_transitionAnimation,
                                              completion: { _ in
                                                if let t = self.t_completion
                                                {
                                                    t()
                                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
