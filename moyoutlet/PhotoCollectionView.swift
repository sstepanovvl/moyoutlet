//
//  PhotoCollectionView.swift
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

import UIKit

let WigglingCollectionViewStartedMovingNotification = "WigglingCollectionView.StartedMoving"
let WigglingCollectionViewFinishedMovingNotification = "WigglingCollectionView.FinishedMoving"

class PhotoCollectionView: UICollectionView {

    var isWiggling: Bool { return _isWiggling }

    private var _isWiggling = false

    override func beginInteractiveMovementForItemAtIndexPath(indexPath: NSIndexPath) -> Bool {
//        startWiggle()
        let cell = self.cellForItemAtIndexPath(indexPath)
        addWiggleAnimationToCell(cell!)
        cell!.layer.zPosition = 1

        NSNotificationCenter.defaultCenter().postNotificationName(WigglingCollectionViewStartedMovingNotification, object: self)
        return super.beginInteractiveMovementForItemAtIndexPath(indexPath)
    }

    override func endInteractiveMovement() {
        super.endInteractiveMovement()
//        stopWiggle()
        for cell in self.visibleCells() {
            cell.layer.removeAllAnimations()
        }
        NSNotificationCenter.defaultCenter().postNotificationName(WigglingCollectionViewFinishedMovingNotification, object: self)
    }

    // Wiggle code below from https://github.com/LiorNn/DragDropCollectionView

    private func startWiggle() {
        for cell in self.visibleCells() {
            addWiggleAnimationToCell(cell as UICollectionViewCell)
        }
        _isWiggling = true
    }

    private func stopWiggle() {
        for cell in self.visibleCells() {
            cell.layer.removeAllAnimations()
        }
        _isWiggling = false
    }

    private func addWiggleAnimationToCell(cell: UICollectionViewCell) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.addAnimation(rotationAnimation(), forKey: "rotation")
//        cell.layer.addAnimation(bounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }

    private func rotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat(0.02)
        let duration = NSTimeInterval(0.1)
        let variance = Double(0.017)
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }

    private func bounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce = CGFloat(1.5)
        let duration = NSTimeInterval(0.18)
        let variance = Double(0.017)
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }

    private func randomizeInterval(interval: NSTimeInterval, withVariance variance:Double) -> NSTimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random;
    }
    
}