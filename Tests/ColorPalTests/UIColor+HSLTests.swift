//  UIColor+HSLTests.swift
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

class UIColor_HSLTests: XCTestCase {
    func testHSLInit() {
        let color = UIColor(HSLValue: HSL(hue: 240 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 240 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueZero() {
        let color = UIColor(HSLValue: HSL(hue: 0 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 0 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueOne() {
        let color = UIColor(HSLValue: HSL(hue: 359 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 359 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueTwoThirds() {
        let color = UIColor(HSLValue: HSL(hue: 241 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 241 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueOneThird() {
        let color = UIColor(HSLValue: HSL(hue: 121 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 121 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueTenPercent() {
        let color = UIColor(HSLValue: HSL(hue: 70 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 70 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitHueSixtyPercent() {
        let color = UIColor(HSLValue: HSL(hue: 216 / 360.0, saturation: 1, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 216 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitNoSaturation() {
        let color = UIColor(HSLValue: HSL(hue: 0, saturation: 0, luminance: 0.5))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 0 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func testHSLInitNoLuminance() {
        let color = UIColor(HSLValue: HSL(hue: 0 / 360.0, saturation: 0.5, luminance: 0.0))
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0, accuracy: 0.005)
    }
    
    func testBlackToHSL() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0, accuracy: 0.005)
    }
    
    func testGreenToHSL() {
        let color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 120 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
    
    func test311B92ToHSL() {
        let color = UIColor(red: 49 / 255.0, green: 27 / 255.0, blue: 146 / 255.0, alpha: 1)
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 251.09 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 0.687, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.339, accuracy: 0.005)
    }
    
    func testFF00EEToHSL() {
        let color = UIColor(red: 255 / 255.0, green: 0 / 255.0, blue: 254 / 255.0, alpha: 1)
        let hsl = color.HSLValue
        
        XCTAssertEqual(hsl.hue, 300 / 360.0, accuracy: 0.005)
        XCTAssertEqual(hsl.saturation, 1, accuracy: 0.005)
        XCTAssertEqual(hsl.luminance, 0.5, accuracy: 0.005)
    }
}
