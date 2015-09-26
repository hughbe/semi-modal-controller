//
//  HBSemiModalNavigationController.swift
//  Semi Modal
//
//  Created by Hugh Bellamy on 29/06/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import UIKit

private struct HBSemiModalDefaultInsets {
    static let Bottom: CGFloat = 0
    static let Leading: CGFloat = 0
    static let Trailing: CGFloat = 0
}

@IBDesignable
class HBSemiModalNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.masksToBounds = true
    }
    
    //MARK: Display
    @IBInspectable var showHideAnimationDuration: CGFloat = 0.25
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            updateMask()
        }
    }
    
    func updateMask() {
        view.roundCorners(.TopRight | .TopLeft, cornerRadius: cornerRadius)
    }
    
    func setupConstraints() {
        leadingConstraint = NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: 0)
        trailingConstraint = NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: 0)
        topConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: 0)
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, topConstraint])
        superview.layoutIfNeeded()
    }
    
    var superview: UIView {
        return view.superview!
    }
    
    private var superviewHeight: CGFloat {
        return superview.frame.height
    }
    
    private var superviewWidth: CGFloat {
        return superview.frame.width
    }
    
    internal var topConstraint: NSLayoutConstraint!
    internal var leadingConstraint: NSLayoutConstraint!
    internal var trailingConstraint: NSLayoutConstraint!
    internal var bottomConstraint: NSLayoutConstraint!
    
    func setTopInset(top: CGFloat?, updateConstraints shouldUpdateConstraints: Bool) {
        var newTopInset = minYOrigin
        if let top = top {
            newTopInset = top
        }
        
        if topConstraint.constant == newTopInset {
            return
        }
        topConstraint.constant = newTopInset
        
        if shouldUpdateConstraints {
            updateConstraints()
        }
    }
    
    func setBottomInset(bottom: CGFloat?, updateConstraints shouldUpdateConstraints: Bool) {
        var newBottomInset = HBSemiModalDefaultInsets.Bottom
        if let bottom = bottom {
            newBottomInset = bottom
        }
        
        if bottomConstraint.constant == newBottomInset {
            return
        }
        bottomConstraint.constant = newBottomInset
        
        if shouldUpdateConstraints {
            updateConstraints()
        }
    }
    
    func setLeadingInset(leading: CGFloat?, updateConstraints shouldUpdateConstraints: Bool) {
        var newLeadingInset = HBSemiModalDefaultInsets.Leading
        if let leading = leading {
            newLeadingInset = leading
        }
        
        if leadingConstraint.constant == newLeadingInset {
            return
        }
        leadingConstraint.constant = newLeadingInset
        
        if shouldUpdateConstraints {
            updateConstraints()
        }
    }
    
    func setTrailingInset(trailing: CGFloat?, updateConstraints shouldUpdateConstraints: Bool) {
        var newTrailingInset = HBSemiModalDefaultInsets.Trailing
        if let trailing = trailing {
            newTrailingInset = trailing
        }
        
        if trailingConstraint.constant == newTrailingInset {
            return
        }
        trailingConstraint.constant = newTrailingInset
        
        if shouldUpdateConstraints {
            updateConstraints()
        }
    }
    
    private func updateConstraints() {
        superview.setNeedsUpdateConstraints()
        superview.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() { //To ensure that corners are rounded
        super.viewWillLayoutSubviews()
        updateMask()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) { //Makes sure the height is maintained when rotated
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let newTransitionHeight = size.height
        let newSuperviewHeight = superview.frame.size.width
        
        let newHeight = newSuperviewHeight * getMaximumHeightPercentage() * heightPercentage
        
        setTopInset(newSuperviewHeight - newHeight, updateConstraints: true)
    }
    
    //MARK: Dragging
    
    var maxYOrigin: CGFloat {
        return superview.frame.height - minimumHeight
    }
    
    var minYOrigin: CGFloat {
        return superview.frame.height - maximumHeight
    }
    
    func setYOrigin(yOrigin: CGFloat) {
        let origin = min(maxYOrigin, max(yOrigin, minYOrigin))
        if(topConstraint.constant != origin) {
            setTopInset(origin, updateConstraints: true)
        }
    }
    
    //MARK: Minimum Height
    var useMinimumHeight = false
    
    var minimumHeightPercentage: CGFloat? { //Defaults to the height of the navigation bar
        didSet {
            if minimumHeightPercentage > 1 {
                minimumHeightPercentage = 1
            } else if minimumHeightPercentage < 0 {
                minimumHeightPercentage = 0
            } else if minimumHeightPercentage > maximumHeightPercentage {
                minimumHeightPercentage = maximumHeightPercentage
            }
        }
    }
    
    private func getMinimumHeightPercentage() -> CGFloat {
        if let minimumHeightPercentage = minimumHeightPercentage where useMinimumHeight {
            return minimumHeightPercentage
        } else {
            return navigationBar.frame.height / superview.frame.height
        }
    }
    
    var minimumHeight: CGFloat {
        return superview.frame.height * getMinimumHeightPercentage()
    }
    
    //MARK: Maximum Height
    var useMaximumHeight = false
    
    var maximumHeightPercentage: CGFloat? { //Defaults to the height of three quarters of the screen
        didSet {
            if maximumHeightPercentage > 1 {
                maximumHeightPercentage = 1
            } else if maximumHeightPercentage < 0 {
                maximumHeightPercentage = 0
            } else if maximumHeightPercentage < minimumHeightPercentage {
                maximumHeightPercentage = minimumHeightPercentage
            }
        }
    }
    
    private func getMaximumHeightPercentage() -> CGFloat {
        if let maximumHeightPercentage = maximumHeightPercentage where useMaximumHeight {
            return maximumHeightPercentage
        } else {
            return 0.75
        }
    }
    
    var maximumHeight: CGFloat {
        return superview.frame.height * getMaximumHeightPercentage()
    }
    
    var heightRange: CGFloat {
        return maximumHeight - minimumHeight
    }
    
    var heightPercentage: CGFloat {
        let range = heightRange
        if range == 0 {
            return 1
        }
        
        let extraSensitivity: CGFloat = 0.05
        let heightInRange = view.frame.height - minimumHeight
        
        let heightPercentage = heightInRange / range + extraSensitivity
        if heightPercentage == extraSensitivity {
            return 0
        }
        return max(0, min(heightPercentage, 1))
    }
    
    func hide() {
        view.removeFromSuperview()
        if let parentViewController = parentViewController {
            removeFromParentViewController()
        }
    }
}

private extension UIView {
    func roundCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        if cornerRadius > 0 {
            let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezierPath.CGPath
            layer.mask = shapeLayer
        } else {
            layer.mask = nil
        }
    }
}

private func roundToPlaces(value:CGFloat, places:Int) -> CGFloat {
    let divisor = pow(10.0, CGFloat(places))
    return round(value * divisor) / divisor
}
