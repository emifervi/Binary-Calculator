//
//  Modal.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 11/18/19.
//  Copyright © 2019 Charmin-Bois. All rights reserved.
//

import UIKit

protocol Modal {
    func show(topController: UIViewController)
    func dismiss()
    var dialogView: UIView {get set}
}

extension Modal where Self:UIView {
    func show(topController: UIViewController) {
        topController.view.addSubview(self)
        self.dialogView.center = CGPoint(x: self.center.x, y: 0)
        let newPoint = CGPoint(x: self.center.x, y: self.dialogView.frame.height * 2)
        UIView.animate(
            withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7,
            initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0),
            animations: {
                self.dialogView.center  = newPoint
            }, completion: { (completed) in
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                    self.dismiss()
                }
            }
        )
    }

    func dismiss() {
        UIView.animate(
            withDuration: 0.33, delay: 0, usingSpringWithDamping: 1,
            initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0),
            animations: {
            self.dialogView.center = CGPoint(x: self.center.x, y: 0)
        }, completion: { (completed) in
            self.removeFromSuperview()
        })
    }
}
