//  ColorSpaceBoxTests.swift
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

func isColorSpaceBoxSorted(box: ColorSpaceBox) -> Bool {
    var lastValue = 0.0
    for sample in box.samples {
        switch (box.longestDimension) {
        case .Red:
            let red = sample.color.RGBValue.red
            if red < lastValue {
                return false
            }
            lastValue = red
        case .Green:
            let green = sample.color.RGBValue.green
            if green < lastValue {
                return false
            }
            lastValue = green
        case .Blue:
            let blue = sample.color.RGBValue.blue
            if blue < lastValue {
                return false
            }
            lastValue = blue
        }
    }
    return true
}

class ColorSpaceBoxTests: XCTestCase {
    let blackAndBlue = [ColorInformation(color: UIColor.blue, population:  50), ColorInformation(color: UIColor.black, population:  50)]
    let blackAndGreen = [ColorInformation(color: UIColor.green, population:  50), ColorInformation(color: UIColor.black, population:  50)]
    let blackAndRed = [ColorInformation(color: UIColor.red, population:  50), ColorInformation(color: UIColor.black, population:  50)]
    let blackAndWhite = [ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.black, population: 50)]
    let redAndBlue = [ColorInformation(color: UIColor.red, population: 50), ColorInformation(color: UIColor.blue, population: 50)]
    let manyColors = [ColorInformation(color: UIColor.black, population: 50), ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.red, population: 50), ColorInformation(color: UIColor.green, population: 50), ColorInformation(color: UIColor.yellow, population: 50), ColorInformation(color: UIColor.blue, population: 50), ColorInformation(color: UIColor.brown, population: 50), ColorInformation(color: UIColor.cyan, population: 50), ColorInformation(color: UIColor.darkGray, population: 50), ColorInformation(color: UIColor.gray, population: 50), ColorInformation(color: UIColor.magenta, population: 50), ColorInformation(color: UIColor.orange, population: 50)]
    
    func testLongestDimensionRed() {
        let box = ColorSpaceBox(samples: blackAndRed)
        XCTAssertEqual(box.longestDimension, ColorSpaceBoxDimension.Red)
    }
    
    func testLongestDimensionGreen() {
        let box = ColorSpaceBox(samples: blackAndGreen)
        XCTAssertEqual(box.longestDimension, ColorSpaceBoxDimension.Green)
    }
    
    func testLongestDimensionBlue() {
        let box = ColorSpaceBox(samples: blackAndBlue)
        XCTAssertEqual(box.longestDimension, ColorSpaceBoxDimension.Blue)
    }
    
    func testLongestDimensionTied() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertEqual(box.longestDimension, ColorSpaceBoxDimension.Blue)

    }
    
    func testVolume() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        
        XCTAssertEqual(box.volume, 8)
    }
    
    func testCanSplitTrue() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertTrue(box.canSplit)
    }
    
    func testCanSplitFalse() {
        let box = ColorSpaceBox(samples: [ColorInformation(color: UIColor.white, population: 50)])
        XCTAssertFalse(box.canSplit)
    }
    
    func testMiddleDimensionValueRed() {
        let box = ColorSpaceBox(samples: blackAndRed)
        XCTAssertEqual(box.middleDimensionValue, 0.5)
    }
    
    func testMiddleDimensionValueGreen() {
        let box = ColorSpaceBox(samples: blackAndGreen)
        XCTAssertEqual(box.middleDimensionValue, 0.5)
    }
    
    func testMiddleDimensionValueBlue() {
        let box = ColorSpaceBox(samples: blackAndBlue)
        XCTAssertEqual(box.middleDimensionValue, 0.5)
    }
    
    func testSampleSplitIndexRed() {
        let box = ColorSpaceBox(samples: blackAndRed)
        XCTAssertEqual(box.sampleSplitIndex, 1)
    }
    
    func testSampleSplitIndexGreen() {
        let box = ColorSpaceBox(samples: blackAndGreen)
        XCTAssertEqual(box.sampleSplitIndex, 1)
    }
    
    func testSampleSplitIndexBlue() {
        let box = ColorSpaceBox(samples: blackAndBlue)
        XCTAssertEqual(box.sampleSplitIndex, 1)
    }
    
    func testAverageColorEqualBlackAndWhite() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertEqual(box.averageColor(), Sample(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), population: 100))
    }
    
    func testAverageColorTwoToOneWhiteAndBlack() {
        let box = ColorSpaceBox(samples: [ColorInformation(color: UIColor.white, population: 100), ColorInformation(color: UIColor.black, population: 50)])
        XCTAssertEqual(box.averageColor(), Sample(color: UIColor(red: 2.0 / 3.0, green: 2.0 / 3.0, blue: 2.0 / 3.0, alpha: 1.0), population: 150))
    }
    
    func testAverageColorTwoToOneBlackAndWhite() {
        let box = ColorSpaceBox(samples: [ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.black, population: 100)])
        XCTAssertEqual(box.averageColor(), Sample(color: UIColor(red: 1.0 / 3.0, green: 1.0 / 3.0, blue: 1.0 / 3.0, alpha: 1.0), population: 150))
    }
    
    func testAverageColorRedAndBlue() {
        let box = ColorSpaceBox(samples: redAndBlue)
        XCTAssertEqual(box.averageColor(), Sample(color: UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1.0), population: 100))
    }
    
    func testSplitCantSplit() {
        let box = ColorSpaceBox(samples: [ColorInformation(color: UIColor.white, population: 50)])
        XCTAssertNil(box.split())
    }
    
    func testSplitCanSplit() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertNotNil(box.split())
    }
    
    func testInitColorOrder() {
        let samples = [ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.red, population: 50), ColorInformation(color: UIColor.black, population: 50)]
        let box = ColorSpaceBox(samples: samples)
        XCTAssert(isColorSpaceBoxSorted(box: box))
    }
    
    func testSplitCanSplitArraySize() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertEqual(box.samples.count, 2)
        let newBox = box.split()
        XCTAssertEqual(box.samples.count, 1)
        XCTAssertEqual(newBox?.samples.count, 1)
    }
    
    func testSplitSortedWithNewLongestDimension() {
        let box = ColorSpaceBox(samples: manyColors)
        let newBox = box.split()
        XCTAssert(isColorSpaceBoxSorted(box: box))
        XCTAssert(isColorSpaceBoxSorted(box: newBox!))
        
        let newNewBox = box.split()
        XCTAssert(isColorSpaceBoxSorted(box: box))
        XCTAssert(isColorSpaceBoxSorted(box: newNewBox!))
        
        // We need to split this many times in order to encounter a new longest dimension
        let newNewNewBox = newBox!.split()
        XCTAssert(isColorSpaceBoxSorted(box: newBox!))
        XCTAssert(isColorSpaceBoxSorted(box: newNewNewBox!))
    }
    
    func testComparison() {
        let biggerVolume = ColorSpaceBox(samples: blackAndWhite)
        let smallerVolume = ColorSpaceBox(samples: blackAndGreen)
        
        XCTAssert(biggerVolume > smallerVolume)
    }
    
    func testEqualsSameSamples() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        let box2 = ColorSpaceBox(samples: blackAndWhite)
        XCTAssertEqual(box, box2)
    }
    
    func testEqualsDifferentSamples() {
        let box = ColorSpaceBox(samples: blackAndWhite)
        let box2 = ColorSpaceBox(samples: blackAndBlue)
        XCTAssertNotEqual(box, box2)
    }
}
