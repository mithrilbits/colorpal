//  Sample.swift
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

// MARK: - Sample struct

/**
    A struct to encapsulate color information in addition to appropriate text color information to overlay on top of the 
    given color.
*/
public struct Sample {
    /**
        The minimum contrast ratio necessary for a title text color to have in order to be readable on top of another 
        color
    */
    private static let titleTextMinimumContrastRatio = 3.0
    /**
        The minimum contrast ratio necessary for a body text color to have in order to be readable on top of another
        color
    */
    private static let bodyTextMinimumContrastRatio = 3.5
    /**
        Information about the color represented by this Sample and its population
    */
    private let colorInformation: ColorInformation
    /**
        The color object represented by this Sample
    */
    public var color: UIColor {
        return colorInformation.color
    }
    /**
        The population of the color represented by this Sample
    */
    public var population: Int {
        return colorInformation.population
    }
    /**
        The RGB value of the color represented by this Sample
    */
    var RGBValue: RGB {
        return colorInformation.RGBValue
    }
    /**
        The HSL value of the color represented by this Sample
    */
    var HSLValue: HSL {
        return colorInformation.HSLValue
    }
    /**
        An appropriate title text color to overlay on top of this sample. The color will be either black or white with 
        alpha applied.
    */
    public let titleTextColor: UIColor
    /**
        An appropriate body text color to overlay on top of this sample. The color will be either black or white with 
        alpha applied.
    */
    public let bodyTextColor: UIColor
    
    /**
        Initialize a sample object.
    
        The initializer will also generate appropriate title and body text colors that can safely be overlaid on top of 
        the color itself.
    
        - parameter color:      The color object represented by the Sample object
        - parameter population: The number of times the color appeared in the sampled image
    */
    init(color: UIColor, population: Int) {
        colorInformation = ColorInformation(color: color, population: population)
        
        self.titleTextColor = color.contrastingTextColorFor(minimumContrastRatio: Sample.titleTextMinimumContrastRatio)
        self.bodyTextColor = color.contrastingTextColorFor(minimumContrastRatio: Sample.bodyTextMinimumContrastRatio)
    }
    
    /**
        Initialize a sample object.
    
        The initializer will also generate appropriate title and body text colors that can safely be overlaid on top of
        the color itself.
    
        - parameter sample: The color information object represented by the Sample object
    */
    init(sample: ColorInformation) {
        self.init(color: sample.color, population: sample.population)
    }
}

// MARK: - Sample implementation of Equatable
extension Sample: Equatable {}

/**
    Determine if two Sample objects are equal.
 
    - note: The RGBValues are compared rather than the color because colors can vary by color space.
 
    - parameter lhs: The first Sample in the evaluation.
    - parameter rhs: The second Sample in the evaluation.
 
    - returns: A bool indicating whether lhs and rhs have the same RGBValue and population
*/
public func ==(lhs: Sample, rhs: Sample) -> Bool {
    return lhs.RGBValue == rhs.RGBValue && lhs.population == rhs.population
}

// MARK: - ColorInformation class

/**
    A struct to encapsulate the color and population information of a given sample
*/
struct ColorInformation {
    /**
        The color object this ColorInformation object represents
    */
    let color: UIColor
    /**
        The number of times this color appeared in the sampled image.
     
        - note: These numbers are relative and not representative of the total number of pixels in the provided image.
        The image may have been resize before it was sampled.
    */
    let population: Int
    /**
        A cached RGB representation of color generated for performance reasons.
    */
    let RGBValue: RGB
    /**
        A cached HSL representation of color generated for performance reasons.
    */
    let HSLValue: HSL
    
    /**
        Initialize a new ColorInformation object.
     
        - parameter color:      The color object this ColorInformation object represents
        - parameter population: The number of times this color appeared in the sampled image
    */
    init(color: UIColor, population: Int) {
        self.color = color
        RGBValue = color.RGBValue
        HSLValue = color.HSLValue
        self.population = population
    }
}

// MARK: - ColorInformation implementation of Equatable
extension ColorInformation: Equatable {}

/**
    Determine if two ColorInformation objects are equal.
 
    - note: The RGBValues are compared rather than the color because colors can vary by color space.
 
    - parameter lhs: The first ColorInformation in the evaluation.
    - parameter rhs: The second ColorInformation in the evaluation.
 
    - returns: A bool indicating whether lhs and rhs have the same RGBValue and population
*/
func ==(lhs: ColorInformation, rhs: ColorInformation) -> Bool {
    return lhs.color.RGBValue == rhs.color.RGBValue && lhs.population == rhs.population
}
