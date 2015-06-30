//
//  HBSlideSemiModalNavigationController.swift
//  Semi Modal
//
//  Created by Hugh Bellamy on 30/06/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import UIKit

protocol HBSlideModalSubclassing {
    func startedDragging()
    func handleDragged(heightPercentage: CGFloat)
    func endedDragging(heightPercentage: CGFloat)
}

private enum DraggingState {
    case Up
    case None
    case Down
}

class HBSlideSemiModalNavigationController: HBSemiModalNavigationController {
    @IBInspectable var shouldDismiss: Bool = false
    @IBInspectable var dismissHeightPercentageThreshold: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addGestureRecognizer(dragDownGestureRecognizer)
    }
    
    @IBInspectable var draggingEnabled: Bool = true {
        didSet {
            dragDownGestureRecognizer.enabled = draggingEnabled
        }
    }
    
    lazy private var dragDownGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: "draggedDown:")
    }()
    
    private var draggingState = DraggingState.None
    private var initialTouchPoint: CGPoint!
    
    func draggedDown(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            initialTouchPoint = view.frame.origin
            startedDragging()
        } else if sender.state == .Changed {
            let barTranslation = sender.translationInView(navigationBar)
            
            if barTranslation.y < 0 && draggingState == .None {
                if view.frame.minY <= minYOrigin + 5 {
                    sender.enabled = false
                    sender.enabled = true
                    return
                } else {
                    draggingState = .Up
                }
            } else if barTranslation.y > 0 {
                draggingState = .Down
            }
            
            handleDragged(heightPercentage)
            setYOrigin(initialTouchPoint.y + barTranslation.y)
        } else {
            endedDragging(heightPercentage)
            draggingState = .None
        }
    }
    
    internal func startedDragging() {}
    internal func handleDragged(heightPercentage: CGFloat) {}
    internal func endedDragging(heightPercentage: CGFloat) {
        if !shouldDismiss {
            return
        }
        
        if heightPercentage > dismissHeightPercentageThreshold {
            setTopInset(nil, updateConstraints: false)
            superview.setNeedsUpdateConstraints()
            UIView.animateWithDuration(NSTimeInterval(showHideAnimationDuration), animations: {
                self.superview.layoutIfNeeded()
            })
        } else {
            setTopInset(superview.frame.size.height, updateConstraints: false)
            superview.setNeedsUpdateConstraints()
            UIView.animateWithDuration(NSTimeInterval(showHideAnimationDuration), animations: {
                self.superview.layoutIfNeeded()
            }, completion: { (finished) in
                    
            })
        }
    }
}
