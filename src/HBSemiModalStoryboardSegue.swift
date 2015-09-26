//
//  HBSemiModalStoryboardSegue.swift
//  Semi Modal
//
//  Created by Hugh Bellamy on 29/06/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import UIKit

class HBSemiModalStoryboardSegue: UIStoryboardSegue {
    override func perform() {
        let destinationViewController = self.destinationViewController as! HBSemiModalNavigationController
        let sourceViewController = self.sourceViewController as! UIViewController
        
        sourceViewController.addChildViewController(destinationViewController)
        sourceViewController.view.addSubview(destinationViewController.view)
        
        destinationViewController.didMoveToParentViewController(sourceViewController)
        destinationViewController.setupConstraints()
        
        let maxValue = max(sourceViewController.view.frame.width, sourceViewController.view.frame.height)
        destinationViewController.setBottomInset(maxValue, updateConstraints: false)
        destinationViewController.setTopInset(maxValue, updateConstraints: true)
        
        destinationViewController.setTopInset(nil, updateConstraints: false)
        destinationViewController.setBottomInset(nil, updateConstraints: false)
        sourceViewController.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(NSTimeInterval(destinationViewController.showHideAnimationDuration), animations: {
            sourceViewController.view.layoutIfNeeded()
        })
    }
}
