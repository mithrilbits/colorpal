//  UIColor+RGB.swift
//
//  Copyright © 2015 James Kelso. All rights reserved.
//
//  The MIT License (MIT)
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit

// MARK: - UIColor RGB Extension
extension UIColor {
    /**
        An RGB struct representing the red, green, and blue values of the color
    */
    var RGBValue: RGB {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return RGB(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

// MARK: - RGB Struct

/**
    A struct representing the red, green, and blue values of the color
*/
struct RGB {
    /**
        A value between 0.0 and 1.0 representing the red value of a color
    */
    let red: Double
    /**
        A value between 0.0 and 1.0 representing the green value of a color
    */
    let green: Double
    /**
        A value between 0.0 and 1.0 representing the blue value of a color
    */
    let blue: Double
    
    /**
        Initialize a new RGB struct
     
        - parameter red:   A value between 0.0 and 1.0 representing the red value of a color
        - parameter green: A value between 0.0 and 1.0 representing the green value of a color
        - parameter blue:  A value between 0.0 and 1.0 representing the blue value of a color
    */
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

// MARK: - RGB Hashable implementation
extension RGB : Hashable {
    func hash(into hasher: inout Hasher) {
        red.hash(into: &hasher)
        green.hash(into: &hasher)
        blue.hash(into: &hasher)
    }
}

/**
    Determine if two RGB structs are equal.
 
    - parameter lhs: The first RGB struct in the evaluation.
    - parameter rhs: The second RGB struct in the evaluation.
 
    - returns: A bool indicating whether lhs and rhs have the same hash value
 */
func ==(lhs: RGB, rhs: RGB) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
