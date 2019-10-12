//
//  ViewController.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 10/11/19.
//  Copyright © 2019 Binary-Boiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var digitsStackView: UIStackView!

    var digitButtons : [UIButton]!
    var hasDecimalDot = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // loadDigitButtons()
    }

    func loadDigitButtons() {
        let innerStackViews = digitsStackView.subviews as! [UIStackView]
        let lastIndex = innerStackViews.count - 1
        for index in 0..<lastIndex {
            let innerDigits = innerStackViews[index].subviews as! [UIButton]
            digitButtons += innerDigits[0...2]
        }
        digitButtons.append(
            innerStackViews[lastIndex].subviews[1] as! UIButton
        )
    }

    @IBAction func addDigit(_ sender: UIButton) {
        var number = numberTextField.text ?? ""
        if number == "0" {
            number = ""
        }
        let digitToAdd = sender.titleLabel!.text!
        if digitToAdd != "." {
            numberTextField.text = number + digitToAdd
        } else if !hasDecimalDot {
            numberTextField.text = number + digitToAdd
            hasDecimalDot = true
        }
    }

    @IBAction func eraseNumber(_ sender: UIButton) {
        numberTextField.text = "0"
        hasDecimalDot = false
    }

    @IBAction func changeSign(_ sender: UIButton) {
        var number = numberTextField.text!
        if number != "0" {
            let isNegative = number.prefix(1) == "-"
            if isNegative {
                number = String(number.suffix(number.count - 1))
            } else {
                number = "-" + number
            }
            numberTextField.text = number
        }
    }
}

