//
//  Operations.swift
//  Binary-Calculator
//
//  Created by Juan Lizarraga on 10/12/19.
//  Copyright © 2019 Binary-Boiz. All rights reserved.
//

import UIKit

class Operations: NSObject {
    
    /*
    static func convert(number: Number, bActual: Base, bDest: Base) -> Number {
        var ans = ""
        
        // Whole
        let wholeDec = Int(number.whole, radix: bActual.rawValue)!
        ans += String(wholeDec, radix: bDest.rawValue)
        
        // Fract
        // TBD
        
        return Number(number: ans, base: bDest);
    }
     */

    static func baseComplementMinus1(_ number: String, _ base: Base) -> Number {
        var ans = String(base.rawValue - 1, radix: base.rawValue, uppercase: true)
        let char = ans
        for _ in 1..<number.count {
            ans += char
        }
        return Number(number: ans, base: base)
    }

    static func radixComplement(_ number: Number) -> Number {
        let base = number.base
        let complementNumber = baseComplementMinus1(number.toString(), base)
        return complementNumber + Number(number: "1", base: base) - number
    }

    static func radixComplementMinus1(_ number: Number) -> Number {
        let base = number.base
        let complementNumber = baseComplementMinus1(number.toString(), base)
        return complementNumber - number
    }
    
    static func storeAsDecimal(_ fract: String, _ base: Base) -> Double {
        var basePow = 1.0
        var result = 0.0
        
        for char in fract {
            basePow /= Double(base.rawValue)
            result += basePow * Double(Int(String(char), radix: base.rawValue)!)
        }
        
        return result
    }
}
