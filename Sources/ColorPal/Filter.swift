//  Filter.swift
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

// MARK: - Filter protocol
/**
    A protocol that defines a standard means of filtering out undesirable colors from a palette.
*/
public protocol Filter {
    /**
        Determine if a given color should pass through the filter.
     
        - parameter color: A color object to be evaluated
     
        - returns: A Bool indicating whether the color passes the filter
    */
    func isAllowed(color: UIColor) -> Bool
}

// MARK: - Default Filter Protocol Implementation
/**
    A default implementation of the filter protocol.

    This filter blocks black, white, and certain red colors.
*/
public class DefaultFilter: Filter {
    /**
        A luminance value at or below which a color should be considered black
    */
    private static let maximumLuminanceforBlack = 0.05
    /**
        A luminance value at or above which a color should be considered white
    */
    private static let minimumLuminanceForWhite = 0.95
    /**
        The minimum hue value a color must have to be considered a disqualified shade of red
    */
    private static let minimumHueForRedILine = 10.0 / 360.0
    /**
        The maximum hue value a color may have to be considered a disqualified shade of red
    */
    private static let maximumHueForRedILine = 37.0 / 360.0
    /**
        The maximum saturation value a color may have to be considered a disqualified shade of red
    */
    private static let maximumSaturationForRedILine = 0.82
    
    /**
        Determine if a given color should pass through the filter.
     
        - parameter color: A color object to be evaluated
     
        - returns: A Bool indicating whether the color isn't considered black or white and isn't a disqualified shade of 
        red
    */
    public func isAllowed(color: UIColor) -> Bool {
        let HSLValue = color.HSLValue
        return !isWhite(HSLValue: HSLValue) && !isBlack(HSLValue: HSLValue) && !isNearRedILine(HSLValue: HSLValue)
    }
    
    /**
        Determine if a given HSL object is considered white.
     
        - parameter HSLValue: An HSL object to be evaluated
     
        - returns: A Bool indicating whether the color is at or above minimumLuminanceForWhite
    */
    private func isWhite(HSLValue: HSL) -> Bool {
        return HSLValue.luminance >= DefaultFilter.minimumLuminanceForWhite
    }
    
    /**
        Determine if a given HSL object is considered black.
     
        - parameter HSLValue: An HSL object to be evaluated
     
        - returns: A Bool indicating whether the color's luminance is at or below maximumLuminanceforBlack
    */
    private func isBlack(HSLValue: HSL) -> Bool {
        return HSLValue.luminance <= DefaultFilter.maximumLuminanceforBlack
    }
    
    /**
        Determine if a given HSL object is a disqualified shade of red.
     
        - parameter HSLValue: An HSL object to be evaluated
     
        - returns: A Bool indicating whether the color's hue is at or between minimumHueForRedILine and 
        maximumHueForRedILine and the color's saturation is at or below maximumSaturationForRedILine
    */
    private func isNearRedILine(HSLValue: HSL) -> Bool {
        return HSLValue.hue >= DefaultFilter.minimumHueForRedILine && HSLValue.hue <= DefaultFilter.maximumHueForRedILine && HSLValue.saturation <= DefaultFilter.maximumSaturationForRedILine
    }
}
