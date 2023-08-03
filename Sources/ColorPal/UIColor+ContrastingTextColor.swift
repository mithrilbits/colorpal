//  UIColor+ContrastingTextColor.swift
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

extension UIColor {
    /**
     Determine the minimum alpha value a color can have and still contrast with a comparison color by at least the
     minimum contrast ratio.
     
     - parameter comparisonColor:        The color to which this color is compared
     - parameter minimumContrastRatio:   The minimum contrast ratio that must be maintained between the two colors
     
     - returns: a minimum alpha value between 0.0 and 1.0, or nil if no alpha value will satisfy the minimum contrast
     ratio
     */
    func minimumContrastingAlphaValueFor(comparisonColor: UIColor, minimumContrastRatio: CGFloat) -> CGFloat? {
        // Limit the number of search iterations for a minimum alpha value
        let maximumSearchIterationsForMinimumAlpha = 10
        // Determine the amount of precision to which we continue to search for a minimum alpha.
        let searchPrecisionForMinimumAlpha: CGFloat = 0.03921569
        
        // Comparison color cannot have transparency
        guard comparisonColor.cgColor.alpha == 1.0 else {
            return nil
        }
        
        let opaqueForeground = self.withAlphaComponent(1.0)
        
        // Determine the contrast ratio if the foreground color is completely opaque
        guard let opaqueRatio = opaqueForeground.contrastRatioFor(comparisonColor: comparisonColor), opaqueRatio >= minimumContrastRatio else {
            // A fully opaque foreground will not have sufficient contrast
            return nil
        }
        
        var minimumAlpha: CGFloat = 0.0
        var maximumAlpha: CGFloat = 1.0
        
        // Perform a binary search for the minimum possible alpha value that still satisfies a minimum contrast ratio.
        // Stop if we perform 10 searches or the difference between the previous two alpha values is less than 0.03921569
        for _ in 0...maximumSearchIterationsForMinimumAlpha where (maximumAlpha - minimumAlpha) > searchPrecisionForMinimumAlpha {
            let testAlpha = (minimumAlpha + maximumAlpha) / 2.0
            let testForeground = self.withAlphaComponent(testAlpha)
            if let testRatio = testForeground.contrastRatioFor(comparisonColor: comparisonColor), testRatio < minimumContrastRatio {
                minimumAlpha = testAlpha
            } else {
                maximumAlpha = testAlpha
            }
        }
        return maximumAlpha
    }
    
    /**
     Determine the contrast ratio between this color and some comparison color.
     
     The result will be a positive value or nil (If this color is translucent).
     
     - parameter comparisonColor: The color to which this color should be compared
     
     - returns: A positive number representing the contrast ratio or nil (if this color is translucent)
     */
    func contrastRatioFor(comparisonColor: UIColor) -> CGFloat? {
        let comparisonColorAlpha = comparisonColor.cgColor.alpha
        // Comparison color can't have transparency
        if comparisonColorAlpha != 1.0 {
            return nil
        }
        
        var primary = self
        let primaryAlpha = primary.cgColor.alpha
        
        if primaryAlpha < 1.0 {
            // If primaryAlpha is translucent, composite the primary color over the comparison color
            primary = primary.compositeOver(backgroundColor: comparisonColor)
        }
        
        let primaryHSL = primary.HSLValue
        let primaryLuminance = primaryHSL.luminance + 0.05
        
        let comparisonHSL = comparisonColor.HSLValue
        let comparisonLuminance = comparisonHSL.luminance + 0.05
        
        return max(primaryLuminance, comparisonLuminance) / min(primaryLuminance, comparisonLuminance)
    }
    
    /**
     Composite over some background color.
     
     - parameter backgroundColor: The color over which to composite
     
     - returns: The composite color
     */
    func compositeOver(backgroundColor: UIColor) -> UIColor {
        var foregroundRed: CGFloat = 0
        var foregroundGreen: CGFloat = 0
        var foregroundBlue: CGFloat = 0
        var foregroundAlpha: CGFloat = 0
        getRed(&foregroundRed, green: &foregroundGreen, blue: &foregroundBlue, alpha: &foregroundAlpha)
        
        var backgroundRed: CGFloat = 0
        var backgroundGreen: CGFloat = 0
        var backgroundBlue: CGFloat = 0
        var backgroundAlpha: CGFloat = 0
        backgroundColor.getRed(&backgroundRed, green: &backgroundGreen, blue: &backgroundBlue, alpha: &backgroundAlpha)
        
        let a: CGFloat = (foregroundAlpha + backgroundAlpha) * (1.0 - foregroundAlpha)
        let r: CGFloat = (foregroundRed * foregroundAlpha) + (backgroundRed * backgroundAlpha * (1.0 - foregroundAlpha))
        let g: CGFloat = (foregroundGreen * foregroundAlpha) + (backgroundGreen * backgroundAlpha * (1.0 - foregroundAlpha))
        let b: CGFloat = (foregroundBlue * foregroundAlpha) + (backgroundBlue * backgroundAlpha * (1.0 - foregroundAlpha))
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /**
     Determine a contrasting text color matching a minimum contrast ratio.
     
     The color will be either black or white with an alpha value applied.
     
     If both white and black satisfy the minimum contrast ratio, the color that satisfies the ratio with the smallest
     alpha value is returned.
     
     - parameter minimumContrastRatio: The minimum contrast ratio the returned color must satisfy.
     
     - returns: A color that contrasts with self by at least the minimum contrast ratio
     */
    func contrastingTextColorFor(minimumContrastRatio: CGFloat) -> UIColor {
        let lightAlpha = UIColor.white.minimumContrastingAlphaValueFor(comparisonColor: self, minimumContrastRatio: minimumContrastRatio)
        var lightColor: UIColor? = nil
        if let lightAlpha = lightAlpha {
            lightColor = UIColor.white.withAlphaComponent(CGFloat(lightAlpha))
        }
        
        let darkAlpha = UIColor.black.minimumContrastingAlphaValueFor(comparisonColor: self, minimumContrastRatio: minimumContrastRatio)
        var darkColor: UIColor? = nil
        if let darkAlpha = darkAlpha {
            darkColor = UIColor.black.withAlphaComponent(CGFloat(darkAlpha))
        }
        
        if darkColor != nil && lightColor != nil {
            return lightAlpha! < darkAlpha! ? lightColor! : darkColor!
        }
        
        if lightColor != nil {
            return lightColor!
        }
        
        return darkColor!
    }
}
