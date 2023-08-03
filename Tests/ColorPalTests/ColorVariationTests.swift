//  ColorVariationTests.swift
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

import XCTest

@testable import ColorPal

class ColorVariationTests: XCTestCase {
    func testInvertedDifferenceSame() {
        let value = 1.0
        let targetValue = 1.0
        
        XCTAssertEqual(invertedDifference(value: value, targetValue: targetValue), 1.0)
    }
    
    func testInvertedDifferenceCompletelyDifferentHigherValue() {
        let value = 1.0
        let targetValue = 0.0
        
        XCTAssertEqual(invertedDifference(value: value, targetValue: targetValue), 0.0)
    }
    
    func testInvertedDifferenceCompletelyDifferentHigherTarget() {
        let value = 0.0
        let targetValue = 1.0
        
        XCTAssertEqual(invertedDifference(value: value, targetValue: targetValue), 0.0)
    }
    
    func testInvertedDifferenceSlightlyDifferentHigherValue() {
        let value = 0.65
        let targetValue = 0.5
        
        XCTAssertEqual(invertedDifference(value: value, targetValue: targetValue), 0.85)
    }
    
    func testInvertedDifferenceSlightlyDifferentHigherTarget() {
        let value = 0.5
        let targetValue = 0.65
        
        XCTAssertEqual(invertedDifference(value: value, targetValue: targetValue), 0.85)
    }
    
    func testWeightedMeanNoValues() {
        let mean = weightedMean()
        XCTAssertEqual(mean, 0.0)
    }
    
    func testWeightedMeanSingleValue() {
        let mean = weightedMean(weightedValues: (value: 1.0, weight: 2.0))
        XCTAssertEqual(mean, 1.0)
    }
    
    func testWeightedMeanSingleValueNoWeight() {
        let mean = weightedMean(weightedValues: (value: 1.0, weight: 0.0))
        XCTAssertEqual(mean, 0.0)
    }
    
    func testWeightedMeanMultipleValues() {
        let mean = weightedMean(weightedValues: (value: 4.0, weight: 5.0), (value: 3.0, weight: 4.0), (value: 1.0, weight: 20.0))
        XCTAssertEqual(mean, 52.0 / 29.0)
    }
    
    func testInit() {
        let variation = ColorVariation(targetLuminance: 0.2, minimumLuminance: 0.1, maximumLuminance: 0.3, targetSaturation: 0.5, minimumSaturation: 0.4, maximumSaturation: 0.6)
        
        XCTAssertEqual(variation.targetLuminance, 0.2)
        XCTAssertEqual(variation.minimumLuminance, 0.1)
        XCTAssertEqual(variation.maximumLuminance, 0.3)
        XCTAssertEqual(variation.targetSaturation, 0.5)
        XCTAssertEqual(variation.minimumSaturation, 0.4)
        XCTAssertEqual(variation.maximumSaturation, 0.6)
    }
    
    func testIsLuminanceWithinRangeTooLow() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 1.0, minimumSaturation: 0.5, maximumSaturation: 1.0)
        XCTAssertFalse(variation.isLuminanceWithinRange(luminance: 0.19))
    }
    
    func testIsLuminanceWithinRangeTooHigh() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 1.0, minimumSaturation: 0.5, maximumSaturation: 1.0)
        XCTAssertFalse(variation.isLuminanceWithinRange(luminance: 0.41))
    }
    
    func testIsLuminanceWithinRangeJustRight() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 1.0, minimumSaturation: 0.5, maximumSaturation: 1.0)
        XCTAssert(variation.isLuminanceWithinRange(luminance: 0.3))
    }
    
    func testIsSaturationWithinRangeTooLow() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 0.9, minimumSaturation: 0.5, maximumSaturation: 0.9)
        XCTAssertFalse(variation.isSaturationWithinRange(saturation: 0.19))
    }
    
    func testIsSaturationWithinRangeTooHigh() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 0.9, minimumSaturation: 0.5, maximumSaturation: 0.9)
        XCTAssertFalse(variation.isSaturationWithinRange(saturation: 1.0))
    }
    
    func testIsSaturationWithinRangeJustRight() {
        let variation = ColorVariation(targetLuminance: 0.3, minimumLuminance: 0.2, maximumLuminance: 0.4, targetSaturation: 0.9, minimumSaturation: 0.5, maximumSaturation: 0.9)
        XCTAssert(variation.isSaturationWithinRange(saturation: 0.8))
    }
    
    func testMatchRatingBadLuminance() {
        let variation = ColorVariation.darkMutedVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.46)), population: 50)
        XCTAssertNil(variation.matchRating(sample: sample, totalPopulation: 50))
    }
    
    func testMatchRatingBadSaturation() {
        let variation = ColorVariation.darkVibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.34, luminance: 0.26)), population: 50)
        XCTAssertNil(variation.matchRating(sample: sample, totalPopulation: 50))
    }
    
    func testMatchRatingNoPopulation() {
        let variation = ColorVariation.vibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5)), population: 0)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 0), 0.9)
    }
    
    func testMatchRatingExact() {
        let variation = ColorVariation.mutedVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.5)), population: 50)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 50)!, 1.0, accuracy: 0.0001)
    }
    
    func testMatchRatingLuminanceMinimum() {
        let variation = ColorVariation.lightVibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.55)), population: 50)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 50)!, 0.886, accuracy: 0.0001)
    }
    
    func testMatchRatingSaturationMinimum() {
        let variation = ColorVariation.lightMutedVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.74)), population: 50)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 50)!, 0.91, accuracy: 0.0001)
    }
    
    func testMatchRatingPopulationMinimum() {
        let variation = ColorVariation.vibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5)), population: 1)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 500)!, 0.9, accuracy: 0.01)
    }
    
    func testMatchRatingEverythingMinimum() {
        let variation = ColorVariation.vibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.36, luminance: 0.31)), population: 1)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 500)!, 0.5942, accuracy: 0.0001)
    }
    
    func testMatchRatingLuminanceMaximum() {
        let variation = ColorVariation.lightVibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.99, luminance: 0.99)), population: 50)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 50)!, 0.847, accuracy: 0.0001)
    }
    
    func testMatchRatingSaturationMaximum() {
        let variation = ColorVariation.lightMutedVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.399, luminance: 0.7399)), population: 50)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 50)!, 0.9702, accuracy: 0.0001)
    }
    
    func testMatchRatingEverythingMaximum() {
        let variation = ColorVariation.mutedVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.399, luminance: 0.699)), population: 500)
        XCTAssertEqual(variation.matchRating(sample: sample, totalPopulation: 500)!, 0.8509, accuracy: 0.01)
    }
    
    func testLocateBestMatchNoMatch() {
        let variation = ColorVariation.vibrantVariation
        let sample = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.34, luminance: 1.0)), population: 500)
        let match = variation.locateBestMatch(samples: [sample])
        XCTAssertNil(match)
    }
    
    func testLocateBestMatch() {
        let variation = ColorVariation.vibrantVariation
        let red = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5)), population: 50)
        let green = Sample(color: UIColor(HSLValue: HSL(hue: 120.0 / 360.0, saturation: 0.9, luminance: 0.49)), population: 50)
        let blue = Sample(color: UIColor(HSLValue: HSL(hue: 240.0 / 360.0, saturation: 0.34, luminance: 0.29)), population: 50)
        XCTAssertEqual(variation.locateBestMatch(samples: [blue, green, red]), red)
    }
}
