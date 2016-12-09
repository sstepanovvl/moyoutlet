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

    fileprivate var _isWiggling = false

    override func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool {
//        startWiggle()
        let cell = self.cellForItem(at: indexPath)
        addWiggleAnimationToCell(cell!)
        cell!.layer.zPosition = 1

        NotificationCenter.default.post(name: Notification.Name(rawValue: WigglingCollectionViewStartedMovingNotification), object: self)
        return super.beginInteractiveMovementForItem(at: indexPath)
    }

    override func endInteractiveMovement() {
        super.endInteractiveMovement()
//        stopWiggle()
        for cell in self.visibleCells {
            cell.layer.removeAllAnimations()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: WigglingCollectionViewFinishedMovingNotification), object: self)
    }

    // Wiggle code below from https://github.com/LiorNn/DragDropCollectionView

    fileprivate func startWiggle() {
        for cell in self.visibleCells {
            addWiggleAnimationToCell(cell as UICollectionViewCell)
        }
        _isWiggling = true
    }

    fileprivate func stopWiggle() {
        for cell in self.visibleCells {
            cell.layer.removeAllAnimations()
        }
        _isWiggling = false
    }

    fileprivate func addWiggleAnimationToCell(_ cell: UICollectionViewCell) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.add(rotationAnimation(), forKey: "rotation")
//        cell.layer.addAnimation(bounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }

    fileprivate func rotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat(0.02)
        let duration = TimeInterval(0.1)
        let variance = Double(0.017)
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }

    fileprivate func bounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce = CGFloat(1.5)
        let duration = TimeInterval(0.18)
        let variance = Double(0.017)
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }

    fileprivate func randomizeInterval(_ interval: TimeInterval, withVariance variance:Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random;
    }
    
}
