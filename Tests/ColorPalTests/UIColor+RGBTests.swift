//  UIColor+RGBTests.swift
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

class UIColor_RGBTests: XCTestCase {
    func test311B92ToRGB() {
        let color = UIColor(red: 49 / 255.0, green: 27 / 255.0, blue: 146 / 255.0, alpha: 1)
        let rgb = color.RGBValue
        
        XCTAssertEqual(rgb.red, 49 / 255.0, accuracy: 0.005)
        XCTAssertEqual(rgb.green, 27 / 255.0, accuracy: 0.005)
        XCTAssertEqual(rgb.blue, 146 / 255.0, accuracy: 0.005)
    }
    
    func testHashValue() {
        let hash = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).RGBValue.hashValue
        
        XCTAssertNotNil(hash)
    }
    
    func testEqual() {
        let white = RGB(red: 1.0, green: 1.0, blue: 1.0)
        
        XCTAssertEqual(RGB(red: 1.0, green: 1.0, blue: 1.0), white)
    }
    
    func testEqualDifferentRed() {
        let white = RGB(red: 0.5, green: 1.0, blue: 1.0)
        
        XCTAssertNotEqual(RGB(red: 1.0, green: 1.0, blue: 1.0), white)
    }
    
    func testEqualDifferentGreen() {
        let white = RGB(red: 1.0, green: 0.5, blue: 1.0)
        
        XCTAssertNotEqual(RGB(red: 1.0, green: 1.0, blue: 1.0), white)
    }
    
    func testEqualDifferentBlue() {
        let white = RGB(red: 1.0, green: 1.0, blue: 0.5)
        
        XCTAssertNotEqual(RGB(red: 1.0, green: 1.0, blue: 1.0), white)
    }
    
    func testEqualDifferent() {
        let white = RGB(red: 0.5, green: 0.5, blue: 0.5)
        
        XCTAssertNotEqual(RGB(red: 1.0, green: 1.0, blue: 1.0), white)
    }
}
