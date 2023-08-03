//  UIColor+ContrastingTextColorTests.swift
//  
//  Created by James Kelso on 10/28/15.
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

class UIColor_ContrastingTextColorTests: XCTestCase {
    func testContrastingTextColorForBlack() {
        let result = UIColor.black.contrastingTextColorFor(minimumContrastRatio: 3.5)
        XCTAssertEqual(result, UIColor.white.withAlphaComponent(0.15625))
    }
    
    func testContrastingTextColorForWhite() {
        let result = UIColor.white.contrastingTextColorFor(minimumContrastRatio: 3.5)
        XCTAssertEqual(result, UIColor.black.withAlphaComponent(0.75))
    }
    
    func testContrastingTextColorForReddish() {
        let result = UIColor(red: 0.75, green: 0.2, blue: 0.2, alpha: 1.0).contrastingTextColorFor(minimumContrastRatio: 2)
        XCTAssertEqual(result, UIColor(white: 0, alpha: 0.5625))
    }
    
    func testMinimumContrastingAlphaValueForTransparentComparison() {
        let result = UIColor.white.minimumContrastingAlphaValueFor(comparisonColor: UIColor.clear, minimumContrastRatio: 3.5)
        XCTAssertNil(result)
    }
    
    func testMinimumContrastingAlphaValueForWhiteOnWhite() {
        let result = UIColor.white.minimumContrastingAlphaValueFor(comparisonColor: UIColor.white, minimumContrastRatio: 3.5)
        XCTAssertNil(result)
    }
    
    func testMinimumContrastingAlphaValueForWhiteOnBlack() {
        let result = UIColor.white.minimumContrastingAlphaValueFor(comparisonColor: UIColor.black, minimumContrastRatio: 3.5)
        XCTAssertEqual(result, 0.15625)
    }
    
    func testMinimumContrastingAlphaValueForBlackOnWhite() {
        let result = UIColor.black.minimumContrastingAlphaValueFor(comparisonColor: UIColor.white, minimumContrastRatio: 3.5)
        XCTAssertEqual(result, 0.75)
    }
    
    func testContrastRatioForTransparentComparison() {
        let result = UIColor.white.contrastRatioFor(comparisonColor: UIColor.clear)
        XCTAssertNil(result)
    }
    
    func testContrastRatioForSolidPrimary() {
        let result = UIColor.white.contrastRatioFor(comparisonColor: UIColor.black)
        XCTAssertEqual(result, 21.0)
    }
    
    func testContrastRatioForSemiTransparentPrimary() {
        let result = UIColor.white.withAlphaComponent(0.5).contrastRatioFor(comparisonColor: UIColor.black)
        XCTAssertEqual(result, 11.0)
    }
    
    func testCompositeOverSolidOnSolid() {
        let resultColor = UIColor.white.compositeOver(backgroundColor: UIColor.black)
        var resultRed: CGFloat = 0
        var resultGreen: CGFloat = 0
        var resultBlue: CGFloat = 0
        var resultAlpha: CGFloat = 0
        resultColor.getRed(&resultRed, green: &resultGreen, blue: &resultBlue, alpha: &resultAlpha)
        
        XCTAssertEqual(resultRed, 1.0, "Incorrect Red Value")
        XCTAssertEqual(resultGreen, 1.0, "Incorrect Green Value")
        XCTAssertEqual(resultBlue, 1.0, "Incorrect Blue Value")
        XCTAssertEqual(resultAlpha, 0.0, "Incorrect Alpha Value")
    }
    
    func testCompositeOverTransparentOnSolid() {
        let resultColor = UIColor.white.withAlphaComponent(0.0).compositeOver(backgroundColor: UIColor.black)
        var resultRed: CGFloat = 0
        var resultGreen: CGFloat = 0
        var resultBlue: CGFloat = 0
        var resultAlpha: CGFloat = 0
        resultColor.getRed(&resultRed, green: &resultGreen, blue: &resultBlue, alpha: &resultAlpha)
        
        XCTAssertEqual(resultRed, 0.0, "Incorrect Red Value")
        XCTAssertEqual(resultGreen, 0.0, "Incorrect Green Value")
        XCTAssertEqual(resultBlue, 0.0, "Incorrect Blue Value")
        XCTAssertEqual(resultAlpha, 1.0, "Incorrect Alpha Value")
    }
    
    func testCompositeOverSemiTransparentOnSolid() {
        let resultColor = UIColor.white.withAlphaComponent(0.5).compositeOver(backgroundColor: UIColor.black)
        var resultRed: CGFloat = 0
        var resultGreen: CGFloat = 0
        var resultBlue: CGFloat = 0
        var resultAlpha: CGFloat = 0
        resultColor.getRed(&resultRed, green: &resultGreen, blue: &resultBlue, alpha: &resultAlpha)
        
        XCTAssertEqual(resultRed, 0.5, "Incorrect Red Value")
        XCTAssertEqual(resultGreen, 0.5, "Incorrect Green Value")
        XCTAssertEqual(resultBlue, 0.5, "Incorrect Blue Value")
        XCTAssertEqual(resultAlpha, 0.75, "Incorrect Alpha Value")
    }
}
