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
    
    var digitButtons: [UIButton] = [UIButton]()
    var hasDecimalDot = false
    
    var prevNum: Number!
    var nextNum: Number!
    
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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Select data
    }

    func showPickerView(_ button: UIButton) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        picker.selectRow(curBase.rawValue - 2, inComponent: 0, animated: false)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneClick))]
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

        if number == "0" && digitToAdd != "." {
            number = ""
        }
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
    
    func changeCurBase(base: Base) -> Void {
        let temp = Number(number: numberTextField.text!, base: curBase)
        temp.updateBase(base)
        numberTextField.text = temp.toString()
        
        curBase = base
        curBaseBtn.setTitle(pickerData[base.rawValue - 2].uppercased(), for: .normal)
        
        for index in 2..<base.rawValue {
            digitButtons[index].isEnabled = true
            digitButtons[index].backgroundColor = UIColor.lightGray
            digitButtons[index].setTitleColor(UIColor.white, for: .normal)
        }
        
        for index in base.rawValue..<16 {
            digitButtons[index].isEnabled = false
            digitButtons[index].backgroundColor = UIColor.darkGray
            digitButtons[index].setTitleColor(UIColor.lightGray, for: .normal)
        }
        
    }
    
    // MARK:- Operations
    
    @IBAction func sum(_ sender: UIButton) {
        storeNumber()
    }
    
    @IBAction func subtract(_ sender: UIButton) {
        storeNumber()
    }
    
    @IBAction func baseComplement(_ sender: UIButton) {
        storeNumber()
    }
    
    @IBAction func convertBase(_ sender: UIButton) {
        // storeNumber()
        showPickerView(sender)
    }
    
    func storeNumber(){
        prevNum = Number(number: numberTextField.text!, base: curBase)
        print(prevNum.whole)
    }
}

