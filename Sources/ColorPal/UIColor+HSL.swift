//  UIColor+HSL.swift
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

// MARK: - UIColor HSL Extension
extension UIColor {
    /**
        An HSL struct representing the hue, saturation, and lightness values of the current color
    */
    var HSLValue: HSL {
        let RGB = self.RGBValue
        
        // Find the minimum RGB Value
        var minimumRGBValue = min(RGB.red, RGB.green)
        minimumRGBValue = min(minimumRGBValue, RGB.blue)

        // Find the maximum RGB Value
        var maximumRGBValue = max(RGB.red, RGB.green)
        maximumRGBValue = max(maximumRGBValue, RGB.blue)
        
        // Find the luminance as determined by averaging max and min values
        let luminance = (maximumRGBValue + minimumRGBValue) / 2
        
        var saturation: CGFloat = 0.0
        // If max and min values are the same, saturation is 0
        if maximumRGBValue != minimumRGBValue {
            // If luminance is smaller than 0.5, Saturation = (max-min)/(max+min)
            if luminance < 0.5 {
                saturation = (maximumRGBValue - minimumRGBValue) / (maximumRGBValue + minimumRGBValue)
            }
                // Otherwise, Saturation = ( max-min)/(2.0-max-min)
            else {
                saturation = (maximumRGBValue - minimumRGBValue) / (2.0 - maximumRGBValue - minimumRGBValue)
            }
        }
        
        var hue: CGFloat = 0
        // If Red is the maximum saturation, Hue = (G-B)/(max-min)
        if maximumRGBValue == RGB.red {
            hue = (RGB.green - RGB.blue) / (maximumRGBValue - minimumRGBValue)
        }
            // If Green is the maximum saturation, Hue = 2.0 + (B-R)/(max-min)
        else if maximumRGBValue == RGB.green {
            hue = 2.0 + ((RGB.blue - RGB.red) / (maximumRGBValue - minimumRGBValue))
        }
            // If Blue is the maximum saturation, Hue = 4.0 + (R-G)/(max-min)
        else {
            hue = 4.0 + ((RGB.red - RGB.green) / (maximumRGBValue - minimumRGBValue))
        }
        // Convert hue to degrees by multiplying by 60
        hue *= 60
        
        // If hue is negative, add 360 to make it positive
        if hue < 0 {
            hue += 360
        }
        
        // Convert hue from degrees to percentage
        hue /= 360
        
        if hue.isNaN {
            hue = 0
        }
        
        return HSL(hue: hue, saturation: saturation, luminance: luminance)
    }
    
    /**
        Initialize a new UIColor object from an HSL struct.
     
        - parameter HSLValue: The HSL struct representing the new UIColor
    */
    convenience init(HSLValue: HSL) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        
        // If saturation == 0, then R, G, and B are equal to the luminance
        if HSLValue.saturation == 0 {
            red = CGFloat(HSLValue.luminance)
            green = CGFloat(HSLValue.luminance)
            blue = CGFloat(HSLValue.luminance)
        } else {
            // Create two temporary values to make the formulas easier to read
            var temp1, temp2: CGFloat
            
            // If luminance < 0.5, temp1 = Luminance * (1.0 + Saturation)
            if HSLValue.luminance < 0.5 {
                temp1 = CGFloat(HSLValue.luminance * (1.0 + HSLValue.saturation))
            }
            // If luminance is equal to or larger than 0.5, temp1 = Luminance + Saturation - (Luminance * Saturation)
            else {
                temp1 = CGFloat(HSLValue.luminance + HSLValue.saturation - (HSLValue.luminance * HSLValue.saturation))
            }
            
            temp2 = CGFloat(2 * HSLValue.luminance) - temp1
            
            // Set red to a temp value
            red = CGFloat(HSLValue.hue + 0.333)
            // If red is greater than 1, make it less than 1 by subtracting 1
            if red > 1 {
                red -= 1
            }
            // Determine actual values based on value of temp red
            if (red * 6) < 1 {
                red = temp2 + (temp1 - temp2) * 6 * red
            } else if (red * 2) < 1 {
                red = temp1
            } else if (red * 3) < 2 {
                red = temp2 + (temp1 - temp2) * (0.666 - red) * 6
            } else {
                red = temp2
            }
            
            // Set green to a temp value
            green = CGFloat(HSLValue.hue)
            // Determine actual values based on value of temp green
            if (green * 6) < 1 {
                green = temp2 + (temp1 - temp2) * 6 * green
            } else if (green * 2) < 1 {
                green = temp1
            } else if (green * 3) < 2 {
                green = temp2 + (temp1 - temp2) * (0.666 - green) * 6
            } else {
                green = temp2
            }
            
            // Set blue to a temp value
            blue = CGFloat(HSLValue.hue - 0.333)
            // If the blue is negative, we make it positive by adding 1
            if blue < 0 {
                blue += 1
            }
            // Determine actual values based on value of temp blue
            if (blue * 6) < 1 {
                blue = temp2 + (temp1 - temp2) * 6 * blue
            } else if (blue * 2) < 1 {
                blue = temp1
            } else if (blue * 3) < 2 {
                blue = temp2 + (temp1 - temp2) * (0.666 - blue) * 6
            } else {
                blue = temp2
            }
        }
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

// MARK: - HSL struct
/**
    A struct representing the hue, saturation, and lightness values of a color
*/
struct HSL {
    /**
        A value between 0.0 and 1.0 representing the hue value of a color
    */
    let hue: CGFloat
    /**
        A value between 0.0 and 1.0 representing the saturation value of a color
    */
    let saturation: CGFloat
    /**
        A value between 0.0 and 1.0 representing the luminance value of a color
    */
    let luminance: CGFloat
    
    /**
        Initialize a new HSL struct
     
        - parameter hue:        A value between 0.0 and 1.0 representing the hue value of a color
        - parameter saturation: A value between 0.0 and 1.0 representing the saturation value of a color
        - parameter luminance:  A value between 0.0 and 1.0 representing the luminance value of a color
    */
    init(hue: CGFloat, saturation: CGFloat, luminance: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.luminance = luminance
    }
}
