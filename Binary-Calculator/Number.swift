//
//  Number.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 10/12/19.
//  Copyright © 2019 Binary-Boiz. All rights reserved.
//

import UIKit

enum Base: Int{
    case Base2 = 2; case Base3; case Base4; case Base5;
    case Base6; case Base7; case Base8; case Base9;
    case Base10; case Base11; case Base12; case Base13;
    case Base14; case Base15; case Base16;
}

class Number: NSObject {

    var whole: Int
    var fract: Double
    var base: Base
    var isNegative: Bool

    init(number: String, base: Base) {
        self.base = base
        let digits = Array(number);

        isNegative = digits[0] == "-"

        if let dotPos = digits.lastIndex(of: ".") {
            let wholeStr = String(digits[0..<dotPos])
            whole = Int(wholeStr, radix: base.rawValue)!

            let fractStr = String(digits[(dotPos + 1)...])
            fract = Operations.storeAsDecimal(fractStr, base)
            
        } else {
            whole = Int(number, radix: base.rawValue)!
            fract = 0.0
        }
    }

    func updateBase(_ base: Base) {
        self.base = base
    }

    func toString() -> String {
        let wholeStr = numberToString(whole)
        let fractStr = (fract == 0.0) ? "" : "." + fractToString()
        
        return isNegative ? "-" + wholeStr : wholeStr + fractStr
    }
    
    private func numberToString(_ number: Int) -> String{
        String(number, radix: base.rawValue, uppercase: true)
    }
    
    private func fractToString() -> String{
        var fractNum = self.fract
        let error = (Decimal(pow(10, -10)) as NSDecimalNumber).doubleValue
        var n = 1
        
        var result = ""
        
        while (fractNum > error && result.count < 15){
            fractNum *= Double(base.rawValue)
            let wholeFractNum = Int(fractNum)
            
            result += numberToString(wholeFractNum)
            
            fractNum -= Double(wholeFractNum)
            n += 1;
        }
        
        return result
    }

    private func addWhole(_ a: Int, isNegative: Bool) {
        if self.isNegative == isNegative {
            self.whole += a
        } else {
            self.whole -= a
        }
        if self.whole < 0 {
            self.whole *= -1
            self.isNegative = !self.isNegative
        }
    }

    private func substractWhole(_ a: Int, isNegative: Bool) {
        self.isNegative == isNegative ? addWhole(a, isNegative: true) :
            addWhole(a, isNegative: false)
    }

    private func addFract(_ s: String) {
        // Do some stuff
    }

    private func substractFract(_ s: String) {
        // Do some stuff
    }

    static func +(a: Number, b: Number) -> Number {
        a.addWhole(b.whole, isNegative: b.isNegative)
        // a.addFract(b.fract)
        return a
    }

    static func -(a: Number, b: Number) -> Number  {
        a.substractWhole(b.whole, isNegative: b.isNegative)
        // a.substractFract(b.fract)
        return a
    }

    static func +=(a: Number, b: Number) {
        a.addWhole(b.whole, isNegative: b.isNegative)
        // a.addFract(b.fract)
    }

    static func -=(a: Number, b: Number) {
        a.substractWhole(b.whole, isNegative: b.isNegative)
        // a.substractFract(b.fract)
    }
}
