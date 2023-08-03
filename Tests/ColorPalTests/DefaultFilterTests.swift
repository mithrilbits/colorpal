//  DefaultFilterTests.swift
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

class DefaultFilterTests: XCTestCase {
    func testIsAllowedBlack() {
        let black = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.04))
        XCTAssertFalse(DefaultFilter().isAllowed(color: black))
    }
    
    func testIsAllowedWhite() {
        let white = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.96))
        XCTAssertFalse(DefaultFilter().isAllowed(color: white))
    }
    
    func testIsAllowedRedILine() {
        let redILine = UIColor(HSLValue: HSL(hue: 15.0 / 360.0, saturation: 0.8, luminance: 0.5))
        XCTAssertFalse(DefaultFilter().isAllowed(color: redILine))
    }
    
    func testIsAllowedRedILineBelowMinimum() {
        let redILine = UIColor(HSLValue: HSL(hue: 9.0 / 360.0, saturation: 0.8, luminance: 0.5))
        XCTAssert(DefaultFilter().isAllowed(color: redILine))
    }
    
    func testIsAllowedRedILineAboveMaximum() {
        let redILine = UIColor(HSLValue: HSL(hue: 38.0 / 360.0, saturation: 0.8, luminance: 0.5))
        XCTAssert(DefaultFilter().isAllowed(color: redILine))
    }
    
    func testIsAllowedRedILineAboveSaturation() {
        let redILine = UIColor(HSLValue: HSL(hue: 15.0 / 360.0, saturation: 1.0, luminance: 0.5))
        XCTAssert(DefaultFilter().isAllowed(color: redILine))
    }
}
