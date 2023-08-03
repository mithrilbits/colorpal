//  UIImage+ResizeTests.swift
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

class UIImage_ResizeTests: XCTestCase {
    var image: UIImage!
    
    override func setUp() {
        image = TestImageSupport.testImageWithColors(colors: UIColor.red, UIColor.black, UIColor.white, UIColor.green, UIColor.blue)
    }
    
    func testScaleHalf() {
        let result = image.scale(scaleRatio: 0.5)
        XCTAssertEqual(result?.size.width, 2)
        XCTAssertEqual(result?.size.height, 2)
    }
    
    func testScale1() {
        let result = image.scale(scaleRatio: 1.0)
        XCTAssertEqual(result?.size.width, 3)
        XCTAssertEqual(result?.size.height, 3)
    }
    
    func testScale2() {
        let result = image.scale(scaleRatio: 2.0)
        XCTAssertEqual(result?.size.width, 6)
        XCTAssertEqual(result?.size.height, 6)
    }
    
    func testResizeToMaxDimensionLessThan() {
        let result = image.resizeToMaxDimension(desiredDimension: 2)
        XCTAssertEqual(result?.size.width, 2)
        XCTAssertEqual(result?.size.height, 2)
    }
    
    func testResizeToMaxDimensionEqualTo() {
        let result = image.resizeToMaxDimension(desiredDimension: 3)
        XCTAssertEqual(result?.size.width, 3)
        XCTAssertEqual(result?.size.height, 3)
    }
    
    func testResizeToMaxDimensionGreaterThan() {
        let result = image.resizeToMaxDimension(desiredDimension: 4)
        XCTAssertEqual(result?.size.width, 3)
        XCTAssertEqual(result?.size.height, 3)
    }
}
