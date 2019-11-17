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
        
        return wholeStr + fractStr
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
            fractNum = charminTruncate(fractNum)
            n += 1;
        }
        
        return result
    }
    
    private func charminTruncate(_ number : Double, _ precision: Int = 10) -> Double {
        let fractPart = number.truncatingRemainder(dividingBy: 1)
        let numDecimals = (pow(10, precision) as NSDecimalNumber).doubleValue
        return Double(round(numDecimals * fractPart)/numDecimals)
    }
    
    private func buildDouble(_ whole: Int, _ fract: Double, _ isNeg: Bool) -> Double {
        var num = Double(abs(whole)) + fract
        if isNeg {
            num *= -1.0
        }
        return num
    }

    private func add(_ otherWhole: Int, _ otherFract: Double, _ otherIsNeg: Bool) {
        let numA = buildDouble(self.whole, self.fract, self.isNegative)
        let numB = buildDouble(otherWhole, otherFract, otherIsNeg)
        
        let res = numA + numB
        
        self.whole = Int(res)
        self.fract = abs(charminTruncate(res - Double(self.whole)))
    }

    private func substract(_ otherWhole: Int, _ otherFract: Double, _ otherIsNeg: Bool) {
        add(otherWhole, otherFract, !otherIsNeg)
    }

    static func +(a: Number, b: Number) -> Number {
        a.add(b.whole, b.fract, b.isNegative)
        return a
    }

    static func -(a: Number, b: Number) -> Number  {
        a.substract(b.whole, b.fract, b.isNegative)
        return a
    }

    static func +=(a: Number, b: Number) {
        a.add(b.whole, b.fract, b.isNegative)
    }

    static func -=(a: Number, b: Number) {
        a.substract(b.whole, b.fract, b.isNegative)
    }
}
