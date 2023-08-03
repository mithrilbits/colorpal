//  ColorVariation.swift
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
// MARK: - Global math functions to support ColorVariation.

/**
    Calculate a weighted mean average.

    - parameter weightedValues: (Variadic) Tuples that consist of a value and its weight
 
    - returns: The weighted mean average
*/
func weightedMean(weightedValues: (value: CGFloat, weight: CGFloat)...) -> CGFloat {
    var valueSum = 0.0
    var weightSum = 0.0
    
    for pair in weightedValues {
        valueSum += (pair.value * pair.weight)
        weightSum += pair.weight
    }
    
    let mean = valueSum / weightSum
    if mean.isNaN {
        return 0
    }
    return mean
}

/**
    Determine how close a value (percentage) is to some target value (percentage)

    A 1.0 indicates that the two values are exactly the same, where a 0.0 indicates that the two values vary by 1.0 
    (100%).

    - parameter value:          The percentage being compared
    - parameter targetValue:    The reference percentage of the comparison

    - returns: A percentage (a number between 0.0 and 1.0)
*/
func invertedDifference(value: CGFloat, targetValue: CGFloat) -> CGFloat {
    return 1.0 - abs(value - targetValue)
}

/**
    Sum the population values of an array of Samples.
 
    - parameter samples: An array of Samples
 
    - returns: The sum of the population values of samples
 */
func totalPopulation(samples: [Sample]) -> Int {
    let value = samples.reduce(0) { (sum: Int, sample: Sample) -> Int in
        return sum + sample.population
    }
    return value
}

// MARK: - ColorVariation struct
/**
    A struct that describes the desired characteristics of a color to perform color matching. It can be used to evaluate 
    different color Samples objects to find the Sample that most closely matches those characteristics.
*/
struct ColorVariation {
    /**
        The ideal luminance value a Sample should have to be considered a match for this ColorVariation
    */
    let targetLuminance: CGFloat
    /**
        The minimum luminance value a Sample should have to be considered a match for this ColorVariation
    */
    let minimumLuminance: CGFloat
    /**
        The maximum luminance value a Sample should have to be considered a match for this ColorVariation
    */
    let maximumLuminance: CGFloat
    
    /**
        The ideal saturation value a Sample should have to be considered a match for this ColorVariation
    */
    let targetSaturation: CGFloat
    /**
        The minimum saturation value a Sample should have to be considered a match for this ColorVariation
    */
    let minimumSaturation: CGFloat
    /**
        The maximum saturation value a Sample should have to be considered a match for this ColorVariation
    */
    let maximumSaturation: CGFloat
    
    /**
        Initialize a new ColorVariation
     
        - parameter targetLuminance:        The ideal luminance value a Sample should have to be considered a match
        - parameter minimumLuminance:       The minimum luminance value a Sample should have to be considered a match
        - parameter maximumLuminance:       The maximum luminance value a Sample should have to be considered a match
        - parameter targetSaturation:       The ideal saturation value a Sample should have to be considered a match
        - parameter minimumSaturation:      The minimum saturation value a Sample should have to be considered a match
        - parameter maximumSaturation:      The maximum saturation value a Sample should have to be considered a match
    */
    init(targetLuminance: CGFloat, minimumLuminance: CGFloat, maximumLuminance: CGFloat, targetSaturation: CGFloat, minimumSaturation: CGFloat, maximumSaturation: CGFloat) {
        self.targetLuminance = targetLuminance
        self.minimumLuminance = minimumLuminance
        self.maximumLuminance = maximumLuminance
        
        self.targetSaturation = targetSaturation
        self.minimumSaturation = minimumSaturation
        self.maximumSaturation = maximumSaturation
    }
}

// MARK: - Common color variations
extension ColorVariation {
    /**
        A color variation describing a color with a high saturation value and a moderate luminance value
    */
    static let vibrantVariation = ColorVariation(targetLuminance: 0.5, minimumLuminance: 0.3, maximumLuminance: 0.7, targetSaturation: 1, minimumSaturation: 0.35, maximumSaturation: 1)
    /**
        A color variation describing a color with moderate luminance value and a low saturation value
    */
    static let mutedVariation = ColorVariation(targetLuminance: 0.5, minimumLuminance: 0.3, maximumLuminance: 0.7, targetSaturation: 0.3, minimumSaturation: 0, maximumSaturation: 0.4)
    /**
        A color variation describing a color with high luminance and saturation values
    */
    static let lightVibrantVariation = ColorVariation(targetLuminance: 0.74, minimumLuminance: 0.55, maximumLuminance: 1, targetSaturation: 1, minimumSaturation: 0.35, maximumSaturation: 1)
    /**
        A color variation describing a color with a high luminance value and a low saturation value
    */
    static let lightMutedVariation = ColorVariation(targetLuminance: 0.74, minimumLuminance: 0.55, maximumLuminance: 1, targetSaturation: 0.3, minimumSaturation: 0, maximumSaturation: 0.4)
    /**
        A color variation describing a color with a high saturation value and a low luminance value
    */
    static let darkVibrantVariation = ColorVariation(targetLuminance: 0.26, minimumLuminance: 0, maximumLuminance: 0.45, targetSaturation: 1, minimumSaturation: 0.35, maximumSaturation: 1)
    /**
        A color variation describing a color with low saturation and luminance values
    */
    static let darkMutedVariation = ColorVariation(targetLuminance: 0.26, minimumLuminance: 0, maximumLuminance: 0.45, targetSaturation: 0.3, minimumSaturation: 0, maximumSaturation: 0.4)
}

// MARK: - ColorVariation matching methods
extension ColorVariation {
    /**
        Locate the Sample that is the closest match for this ColorVariation (if it exists).
     
        This method works by determining a match rating for each Sample and then determining the Sample with the highest 
        match rating.
     
        - parameter samples: An array of samples from which to select the match
     
        - returns: The Sample that is the closest match
    */
    func locateBestMatch(samples: [Sample]) -> Sample? {
        var highestMatch: (sample: Sample, matchRating: CGFloat)? = nil
        
        let population = totalPopulation(samples: samples)
        
        for sample in samples {
            guard let rating = matchRating(sample: sample, totalPopulation: population) else {
                continue
            }
            
            if highestMatch == nil || rating > highestMatch!.matchRating {
                highestMatch = (sample: sample, matchRating: rating)
            }
        }
        return highestMatch != nil ? highestMatch!.sample : nil
    }
    
    /**
        Rate how closely the Sample matches this ColorVariation.
     
        The rating is determined by performing a weighted average of how closely the luminance and saturation match the 
        target value, and how much of the total population this Sample covers.
     
        Luminance is the most important determining factor, followed by saturation. Population serves as a tie-breaker 
        for two samples that rate similarly between luminance and saturation where the Sample with higher population is 
        considered a better match.
     
        - note: A disqualified Sample is one that falls outside of the minimum or maximum luminance or saturation values 
        for this variation.
     
        - parameter sample:             The Sample object to evaluate
        - parameter totalPopulation:    The total population of all Samples being evaluated
     
        - returns: A rating between 0.0 and 1.0, or nil. 0.0 indicates a poor match, where 1.0 indicates a perfect match, 
        and nil indicates a disqualified Sample.
     */
    func matchRating(sample: Sample, totalPopulation: Int) -> CGFloat? {
        let HSLValue = sample.HSLValue
        
        if !isLuminanceWithinRange(luminance: HSLValue.luminance) || !isSaturationWithinRange(saturation: HSLValue.saturation) {
            return nil
        }
        
        let saturationDiff = invertedDifference(value: HSLValue.saturation, targetValue: targetSaturation)
        let luminanceDiff = invertedDifference(value: HSLValue.luminance, targetValue: targetLuminance)
        var populationDiff = CGFloat(sample.population) / CGFloat(totalPopulation)
        if populationDiff.isNaN {
            populationDiff = 0
        }
        
        // Population has weight 1, where saturation has weight 3, and luminance has weight 6.
        return weightedMean(weightedValues: (value: saturationDiff, weight: 3), (value: luminanceDiff, weight: 6), (value: populationDiff, weight: 1))
    }
    
    /**
        A convenience method to determine if the given luminance value falls inside the acceptable range for this 
        ColorVariation.
     
        - parameter luminance: The luminance value being compared
     
        - returns: A Boolean indicating whether the value falls within the acceptable range.
    */
    func isLuminanceWithinRange(luminance: CGFloat) -> Bool {
        return luminance >= minimumLuminance && luminance <= maximumLuminance
    }
    
    /**
        A convenience method to determine if the given saturation value falls inside the acceptable range for this
        ColorVariation.
     
        - parameter saturation: The saturation value being compared
     
        - returns: A Boolean indicating whether the value falls within the acceptable range.
     */
    func isSaturationWithinRange(saturation: CGFloat) -> Bool {
        return saturation >= minimumSaturation && saturation <= maximumSaturation
    }
}
