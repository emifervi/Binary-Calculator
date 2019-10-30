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
    var fract: String!
    var base: Base
    var isNegative: Bool

    init(number: String, base: Base) {
        self.base = base
        let digits = Array(number);
        
        isNegative = digits[0] == "-"
        
        if let dotPos = digits.lastIndex(of: ".") {
            let wholeStr = String(digits[0..<dotPos])
            whole = Int(wholeStr, radix: base.rawValue)!
            
            // let fractStr = String(digits[(dotPos + 1)...])
            fract = ""
        } else {
            whole = Int(number, radix: base.rawValue)!
        }
    }

    func updateBase(_ base: Base) {
        self.base = base
    }

    func toString() -> String {
        String(whole, radix: base.rawValue, uppercase: true)
    }
}
