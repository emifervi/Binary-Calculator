//
//  ViewController.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 10/11/19.
//  Copyright © 2019 Binary-Boiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var digitsStackView: UIStackView!
    @IBOutlet weak var curBaseBtn: UIButton!
    @IBOutlet weak var acBtn: UIButton!
    @IBOutlet weak var baseComplementBtn: UIButton!

    var digitButtons: [UIButton] = [UIButton]()
    var hasDecimalDot = false

    var prevNum: Number!
    var prevOperation = ""
    var highlightedButton : UIButton!

    var curBase = Base.Base10

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDigitButtons()
    }

    // MARK:- Pickerview functions

    var picker: UIPickerView!
    var toolBar: UIToolbar!

    let pickerData = [
        "Base 2", "Base 3", "Base 4", "Base 5", "Base 6",
        "Base 7", "Base 8", "Base 9", "Base 10", "Base 11",
        "Base 12", "Base 13", "Base 14", "Base 15", "Base 16"
    ]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func initializePickerView() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        picker.selectRow(curBase.rawValue - 2, inComponent: 0, animated: false)
    }

    func initializeToolbar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneClick))]
    }

    func showPickerView(_ button: UIButton) {
        if picker == nil {
            initializePickerView()
        }
        self.view.addSubview(picker)

        if toolBar == nil {
            initializeToolbar()
        }
        self.view.addSubview(toolBar)
    }

    @objc func doneClick() {
        let selectedBase = Base(rawValue: picker.selectedRow(inComponent: 0) + 2)!
        changeCurBase(base: selectedBase)

        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }

    // MARK:- UI functions

    func loadDigitButtons() {
        let innerStackViews = digitsStackView.subviews as! [UIStackView]
        let lastIndex = innerStackViews.count - 1
        for index in 0..<lastIndex {
            let innerDigits = innerStackViews[index].subviews as! [UIButton]
            digitButtons += innerDigits[0...2].reversed()
        }
        digitButtons.append(
            innerStackViews[lastIndex].subviews[1] as! UIButton
        )
        digitButtons = digitButtons.reversed()
    }

    @IBAction func addDigit(_ sender: UIButton) {
        var number = numberTextField.text ?? ""
        let digitToAdd = sender.titleLabel!.text!

        if highlightedButton != nil {
            number = ""
            unHighlightButton()
        }

        if number == "0" && digitToAdd != "." {
            number = ""
        }
        if digitToAdd != "." {
            updateTextField(number, digitToAdd)
        } else if !hasDecimalDot {
            if number == "" {
                number = "0"
            }
            disableBaseComplementBtn()
            updateTextField(number, digitToAdd)
            hasDecimalDot = true
        }
    }

    func updateTextField(_ number: String, _ digitToAdd: String) {
        numberTextField.text = number + digitToAdd
        acBtn.setTitle("C", for: .normal)
    }

    @IBAction func eraseNumber(_ sender: UIButton) {
        if numberTextField.text == "0" {
            prevOperation = ""
            prevNum = nil
            if highlightedButton != nil {
                unHighlightButton()
            }
        }
        numberTextField.text = "0"
        hasDecimalDot = false
        acBtn.setTitle("AC", for: .normal)
        enableBaseComplementBtn()
    }

    @IBAction func changeSign(_ sender: UIButton) {
        var number = numberTextField.text!
        if number != "0" {
            let isNegative = number.prefix(1) == "-"
            if isNegative {
                number = String(number.suffix(number.count - 1))
                enableBaseComplementBtn()
            } else {
                number = "-" + number
                disableBaseComplementBtn()
            }
            numberTextField.text = number
        }
    }

    func enableBaseComplementBtn() {
        let btnColor: UIColor = .systemOrange
        enableButton(baseComplementBtn, color: btnColor)
    }

    func disableBaseComplementBtn() {
        let btnColor = UIColor(red: 167.0 / 255, green: 98.0 / 255, blue: 1.0 / 255, alpha: 1.0)
        disableButton(baseComplementBtn, color: btnColor)
    }

    func changeCurBase(base: Base) -> Void {
        storeNumber()
        prevNum.updateBase(base)
        numberTextField.text = prevNum.toString()

        curBase = base
        curBaseBtn.setTitle(pickerData[base.rawValue - 2].uppercased(), for: .normal)

        for index in 2..<base.rawValue {
            enableButton(digitButtons[index])
        }

        for index in base.rawValue..<16 {
            disableButton(digitButtons[index])
        }
    }

    func enableButton(_ button: UIButton, color: UIColor = .lightGray) {
        button.isEnabled = true
        button.backgroundColor = color
        button.setTitleColor(UIColor.white, for: .normal)
    }

    func disableButton(_ button: UIButton, color: UIColor = .darkGray) {
        button.isEnabled = false
        button.backgroundColor = color
        button.setTitleColor(UIColor.lightGray, for: .normal)
    }

    func unHighlightButton() {
        highlightedButton.backgroundColor = .systemOrange
        highlightedButton.setTitleColor(.white, for: .normal)
        highlightedButton = nil
    }

    func highlightButton(_ button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(.systemOrange, for: .normal)
        highlightedButton = button
    }

    func showBaseComplementAlert() {
        let alert = UIAlertController(title: "¿Cuál acción quieres hacer?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Complemento a la base", style: .default, handler: { (_) in
            self.prevNum = Operations.radixComplement(self.curNumber())
            self.updateTextField()
        }))
        alert.addAction(UIAlertAction(title: "Complemento a la base disminuida", style: .default, handler: { (_) in
            self.prevNum = Operations.radixComplementMinus1(self.curNumber())
            self.updateTextField()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    // MARK:- Operations

    func curNumber() -> Number {
        Number(number: numberTextField.text!, base: curBase)
    }

    @IBAction func sum(_ sender: UIButton) {
        if prevNum == nil {
            storeNumber()
        } else {
            performOperations()
        }
        prevOperation = "+"
        highlightButton(sender)
    }

    @IBAction func subtract(_ sender: UIButton) {
        if prevNum == nil {
            storeNumber()
        } else {
            performOperations()
        }
        prevOperation = "-"
        highlightButton(sender)
    }

    @IBAction func baseComplement(_ sender: UIButton) {
        showBaseComplementAlert()
    }

    @IBAction func convertBase(_ sender: UIButton) {
        showPickerView(sender)
    }

    @IBAction func equalsAction(_ sender: UIButton) {
        performOperations()
        prevOperation = "="
        prevNum = nil
    }

    func performOperations() {
        switch prevOperation {
        case "+":
            prevNum += curNumber()
            break
        case "-":
            prevNum -= curNumber()
            break
        default:
            break
        }
        updateTextField()
    }

    func updateTextField() {
        numberTextField.text = prevNum.toString()
    }

    func storeNumber(){
        prevNum = curNumber()
        hasDecimalDot = false
        
        if prevNum.fract == 0 {
            enableBaseComplementBtn()
        }
    }
}
