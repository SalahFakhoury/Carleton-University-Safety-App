//
//  HelperUtility.swift
//  uwbtestapp
//
//  Created by Arafat Hossain on 29/10/22.
//

import Foundation

class HelperUtility {
    
    static func getNumber(requiredDigit: Int, number: Float) -> Float {
        let digitNumber = pow(Double(10),Double(requiredDigit))

        return Float(round(digitNumber * Double(number)) / digitNumber)
    }
}
