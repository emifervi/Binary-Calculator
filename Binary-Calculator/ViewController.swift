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
        numberTextField.text = number + sender.titleLabel!.text!
    }

}

