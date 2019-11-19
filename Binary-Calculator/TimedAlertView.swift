//
//  TimedAlertView.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 11/18/19.
//  Copyright © 2019 Charmin-Bois. All rights reserved.
//

import UIKit

class TimedAlertView: UIView, Modal {

    var dialogView = UIView()

    convenience init(title: String) {
        self.init(frame: UIScreen.main.bounds)
        initialiser(title)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialiser(_ title: String) {
        dialogView.clipsToBounds = true
        let dialogViewWidth = frame.width / 1.5
        let titleLabel = addTitleView(title, dialogViewWidth)
        let dialogViewHeight = titleLabel.frame.height + 8
        addDialogView(dialogViewWidth, dialogViewHeight)

    }

    func addTitleView(_ title: String, _ dialogViewWidth: CGFloat) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 4, width: dialogViewWidth, height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        dialogView.addSubview(titleLabel)
        return titleLabel
    }

    func addDialogView(_ dialogViewWidth: CGFloat, _ dialogViewHeight: CGFloat) {
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = .darkGray
        dialogView.layer.cornerRadius = 6
        dialogView.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        addSubview(dialogView)
    }
}
