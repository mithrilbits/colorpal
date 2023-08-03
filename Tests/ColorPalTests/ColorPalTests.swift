//  SwiftPaletteTests.swift
//  
//  Created by James Kelso on 11/2/15.
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

class ColorPalTests: XCTestCase {
    func testInit() {
        let result = ColorPal(image: testImage2By()).samples
        
        XCTAssert(result!.contains(Sample(color: UIColor.red, population: 1)))
        XCTAssert(result!.contains(Sample(color: UIColor.green, population: 1)))
    }
    
    func testAsync() {
        let expectation = expectation(description: "Async complete")
        ColorPal.async(image: testImage2By(), completion: { (palette: ColorPal) in
            let result = palette.samples
            
            XCTAssert(result!.contains(Sample(color: UIColor.red, population: 1)))
            XCTAssert(result!.contains(Sample(color: UIColor.green, population: 1)))
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testVibrant() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.vibrantSample)
    }
    
    func testLightVibrant() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.lightVibrantSample)
    }
    
    func testDarkVibrant() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.darkVibrantSample)
    }
    
    func testMuted() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.mutedSample)
    }
    
    func testLightMuted() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.lightMutedSample)
    }
    
    func testDarkMuted() {
        let palette = ColorPal(image: testImagePerfect())
        XCTAssertNotNil(palette.darkMutedSample)
    }
    
    func testVibrantSampleColorWithDefaultNonDefault() {
        let palette = ColorPal(image: testImagePerfect())
        let defaultColor = UIColor.black
        
        XCTAssertNotEqual(palette.vibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testVibrantSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.vibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testLightVibrantSampleColorWithDefaultNonDefault() {
        let palette = ColorPal(image: testImagePerfect())
        let defaultColor = UIColor.black
        
        XCTAssertNotEqual(palette.lightVibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testLightVibrantSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.lightVibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testDarkVibrantSampleColorWithDefaultNonDefault() {
        let palette = ColorPal(image: testImagePerfect())
        let defaultColor = UIColor.black
        
        XCTAssertNotEqual(palette.darkVibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testDarkVibrantSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.darkVibrantSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testMutedSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.mutedSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testLightMutedSampleColorWithDefaultNonDefault() {
        let palette = ColorPal(image: testImagePerfect())
        let defaultColor = UIColor.black
        
        XCTAssertNotEqual(palette.lightMutedSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testLightMutedSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.lightMutedSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testDarkMutedSampleColorWithDefaultNonDefault() {
        let palette = ColorPal(image: testImagePerfect())
        let defaultColor = UIColor.black
        
        XCTAssertNotEqual(palette.darkMutedSampleColorWithDefault(color: defaultColor), defaultColor)
    }
    
    func testDarkMutedSampleColorWithDefault() {
        let palette = ColorPal(image: testImage1By())
        let defaultColor = UIColor.black
        
        XCTAssertEqual(palette.darkMutedSampleColorWithDefault(color: defaultColor), defaultColor)
    }
}
