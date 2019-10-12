//
//  Number.swift
//  Binary-Calculator
//
//  Created by Ricardo González Castillo on 10/12/19.
//  Copyright © 2019 Binary-Boiz. All rights reserved.
//

import UIKit

enum Base {
    case Binary; case Terniary; case Four; case Five;
    case Six; case Seven; case Octal; case Nine;
    case Decimal; case Undecimal; case Duodecimal;
    case Thirdecimal; case Fourthdecimal; case Fifthdecimal;
    case Hexadecimal;
}

class Number: NSObject {

    var number: String!

    init(number: String) {
        self.number = number
    }

}
