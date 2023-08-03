//  SampleTests.swift
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

class SampleTests: XCTestCase {
    var sample: Sample!
    
    override func setUp() {
        sample = Sample(color: UIColor.black, population: 50)
    }
    
    override func tearDown() {
        sample = nil
    }
    
    func testInitColor() {
        XCTAssertEqual(sample.color, UIColor.black)
    }
    
    func testPopulation() {
        XCTAssertEqual(sample.population, 50)
    }
    
    func testTitleTextColor() {
        XCTAssertNotNil(sample.titleTextColor)
    }
    
    func testBodyTextColor() {
        XCTAssertNotNil(sample.bodyTextColor)
    }
    
    func testEqual() {
        XCTAssertEqual(sample, Sample(color: UIColor.black, population: 50))
    }
    
    func testEqualRGB() {
        XCTAssertEqual(sample, Sample(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), population: 50))
    }
    
    func testEqualDifferentColor() {
        XCTAssertNotEqual(sample, Sample(color: UIColor.white, population: 50))
    }
    
    func testEqualDifferentPopulation() {
        XCTAssertNotEqual(sample, Sample(color: UIColor.black, population: 1))
    }
    
    func testEqualDifferentEverything() {
        XCTAssertNotEqual(sample, Sample(color: UIColor.white, population: 1))
    }
}
