//
//  HBZoomSemiModalViewController.swift
//  Semi Modal
//
//  Created by Hugh Bellamy on 29/06/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import UIKit

enum HBZoomDirection {
    case ToRight
    case ToLeft
}

@IBDesignable
class HBZoomSemiModalViewController: HBSlideSemiModalNavigationController, HBSlideModalSubclassing {
    @IBInspectable var zoomExtraWidthPercentage: CGFloat = 0.2
    
    override func startedDragging() { }
    
    var previousInset: CGFloat?
    
    var zoomDirection = HBZoomDirection.ToRight
    
    override func handleDragged(heightPercentage: CGFloat) {
        let progress = 1 - (heightPercentage)
        let newInset = progress * superview.frame.width
                
        if let previousInset = previousInset where previousInset == newInset {
            return
        }
        
        previousInset = newInset
        if zoomDirection == .ToRight {
            setLeadingInset(newInset, updateConstraints: false)
        } else if zoomDirection == .ToLeft {
            setTrailingInset(newInset, updateConstraints: false)
        }
    }
    
    override func endedDragging(heightPercentage: CGFloat) {
        if !shouldDismiss {
            return
        }
        
        let progress = heightPercentage
        if progress > dismissHeightPercentageThreshold {
            if zoomDirection == .ToRight {
                setLeadingInset(nil, updateConstraints:	 false)
            } else if zoomDirection == .ToLeft {
                setTrailingInset(nil, updateConstraints: false)
            }
            
            setTopInset(nil, updateConstraints: false)
            superview.setNeedsUpdateConstraints()
            UIView.animateWithDuration(NSTimeInterval(showHideAnimationDuration), animations: {
                self.superview.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(NSTimeInterval(showHideAnimationDuration), animations: {
                if self.zoomDirection == .ToRight {
                    self.view.frame.origin = CGPointMake(self.superview.frame.width, self.superview.frame.height)
                } else if self.zoomDirection == .ToLeft {
                    self.view.frame.origin = CGPointMake(-self.superview.frame.width, self.superview.frame.height)
                }
            }, completion: { (finished) in
                self.hide()
            })
        }
    }
}
