//  VariationMapTests.swift
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

class VariationMapTests: XCTestCase {
    let idealVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5)), population: 50)
    let minimumVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.3)), population: 50)
    let maximumVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.7)), population: 50)
    
    let idealMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.5)), population: 50)
    let minimumMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.3)), population: 50)
    let maximumMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 0.7)), population: 50)
    
    let idealLightVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.74)), population: 50)
    let minimumLightVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.55)), population: 50)
    let maximumLightVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 1.0)), population: 50)
    
    let idealLightMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.74)), population: 50)
    let minimumLightMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.55)), population: 50)
    let maximumLightMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 1.0)), population: 50)
    
    let idealDarkVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.26)), population: 50)
    let minimumDarkVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.0)), population: 50)
    let maximumDarkVibrant = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.45)), population: 50)
    
    let idealDarkMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.26)), population: 50)
    let minimumDarkMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.0)), population: 50)
    let maximumDarkMuted = Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 0.45)), population: 50)
    
    func testMapVibrantOnly() {
        let variationMap = DefaultVariationMap()
        variationMap.map(samples: [idealVibrant])
        
        XCTAssertNotNil(variationMap.vibrantSample)
        XCTAssertNotNil(variationMap.darkVibrantSample)
    }
    
    func testMapColorVariationsAll() {
        let variationMap = DefaultVariationMap()
        variationMap.mapColorVariations(samples: [idealVibrant, minimumVibrant, maximumVibrant, idealMuted, minimumMuted, maximumMuted, idealLightVibrant, minimumLightVibrant, maximumLightVibrant, idealLightMuted, minimumLightMuted, maximumLightMuted, idealDarkVibrant, minimumDarkVibrant, maximumDarkVibrant, idealDarkMuted, minimumDarkMuted, maximumDarkMuted])
        
        XCTAssertEqual(variationMap.vibrantSample, idealVibrant)
        XCTAssertEqual(variationMap.mutedSample, idealMuted)
        XCTAssertEqual(variationMap.lightVibrantSample, idealLightVibrant)
        XCTAssertEqual(variationMap.lightMutedSample, idealLightMuted)
        XCTAssertEqual(variationMap.darkVibrantSample, idealDarkVibrant)
        XCTAssertEqual(variationMap.darkMutedSample, idealDarkMuted)
    }
    
    func testGenerateMissingColorVariationsNoDark() {
        let variationMap = DefaultVariationMap()
        variationMap.vibrantSample = idealVibrant
        variationMap.generateMissingColorVariations()
        XCTAssertEqual(variationMap.darkVibrantSample, Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.26)), population: 0))
    }
    
    func testGenerateMissingColorVariationsNoVibrant() {
        let variationMap = DefaultVariationMap()
        variationMap.darkVibrantSample = idealDarkVibrant
        variationMap.generateMissingColorVariations()
        XCTAssertEqual(variationMap.vibrantSample, Sample(color: UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5)), population: 0))
    }
    
    func testGenerateMissingColorVariationsNeither() {
        let variationMap = DefaultVariationMap()
        variationMap.generateMissingColorVariations()
        XCTAssertNil(variationMap.vibrantSample)
        XCTAssertNil(variationMap.darkVibrantSample)
    }
}
