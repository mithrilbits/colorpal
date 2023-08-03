//  QuantizerTests.swift
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

class QuantizerTests: XCTestCase {
    func testQuantizeSamplesUnderMaximumNumber() {
        let samples = [ColorInformation(color: UIColor.black, population: 50)]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let result = quantizer.quantizeSamples(samples: samples, paletteSize: .Default)
        XCTAssertEqual(result, [Sample(sample: samples[0])])
    }
    
    func testInitSamples() {
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let result = quantizer.samples
        
        XCTAssert(result!.contains(Sample(color: UIColor.red, population: 1)))
        XCTAssert(result!.contains(Sample(color: UIColor.white, population: 1)))
        XCTAssert(result!.contains(Sample(color: UIColor.black, population: 1)))
        XCTAssert(result!.contains(Sample(color: UIColor.green, population: 1)))
    }
    
    func testInitSampleValuesPopulationTotal() {
        let quantizer = Quantizer(image: testImagePerfect(), filters: [Filter](), paletteSize: .Default)
        let populationTotal = quantizer.samples?.reduce(0) {
            $0 + $1.population
        }
        
        XCTAssertEqual(populationTotal, 5 * 5)
    }
    
    func testQuantizeSamplesAverageColor() {
        let samples = [ColorInformation(color: UIColor.black, population: 50), ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.red, population: 50)]
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let result = quantizer.quantizeSamples(samples: samples, paletteSize: .Micro)
        
        // Quantizer should deliver two samples. The first will be one that averages black and red together, which averages to 0.5, 0, 0. The next sample will be plain white.
        XCTAssert(result.contains(Sample(color: UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0), population: 100)))
        XCTAssert(result.contains(Sample(color: UIColor.white, population: 50)))
    }
    
    func testQuantizeSamplesSplitAndAverage() {
        let samples = [ColorInformation(color: UIColor.black, population: 50), ColorInformation(color: UIColor.white, population: 50), ColorInformation(color: UIColor.red, population: 50), ColorInformation(color: UIColor.blue, population: 50)]
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let result = quantizer.quantizeSamples(samples: samples, paletteSize: .Micro)
        
        // Quantizer should split into two boxes, one containing blue and white, and one containing red and black. Blue and white should average to .5, .5, 1, and red and black should average to .5, 0, 0.
        XCTAssertEqual([Sample(color: UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1.0), population: 100), Sample(color: UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0), population: 100)], result)
    }
    
    func testShouldIgnoreColorRGBWhite() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(RGBValue: RGB(red: 1.0, green: 1.0, blue: 1.0)))
    }
    
    func testShouldIgnoreColorUIColorWhite() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(color: UIColor.white))
    }
    
    func testShouldIgnoreColorRGBGreen() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssertFalse(quantizer.shouldIgnoreColor(RGBValue: RGB(red: 0.0, green: 1.0, blue: 0.0)))
    }
    
    func testShouldIgnoreColorUIColorGreen() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssertFalse(quantizer.shouldIgnoreColor(color: UIColor.green))
    }
    
    func testShouldIgnoreColorRGBBlack() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(RGBValue: RGB(red: 0.0, green: 0.0, blue: 0.0)))
    }
    
    func testShouldIgnoreColorUIColorBlack() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(color: UIColor.black))
    }
    
    func testShouldIgnoreColorRGBRed() {
        let filters: [Filter] = [BlockBlack(), BlockWhite(), BlockRed()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(RGBValue: RGB(red: 1.0, green: 0.0, blue: 0.0)))
    }
    
    func testShouldIgnoreColorUIColorRed() {
        let filters: [Filter] = [BlockBlack(), BlockWhite(), BlockRed()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssert(quantizer.shouldIgnoreColor(color: UIColor.red))
    }
    
    func testShouldIgnoreColorRGBBlue() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssertFalse(quantizer.shouldIgnoreColor(RGBValue: RGB(red: 0.0, green: 0.0, blue: 1.0)))
    }
    
    func testShouldIgnoreColorUIColorBlue() {
        let filters: [Filter] = [BlockBlack(), BlockWhite()]
        let quantizer = Quantizer(image: testImage2By(), filters: filters, paletteSize: .Default)
        
        XCTAssertFalse(quantizer.shouldIgnoreColor(color: UIColor.blue))
    }
    
    func testConvertPixelstoRGBContainsBlack() {
        let tuple = testImagePerfect().pixels()
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let RGBMap = quantizer.convertPixelsToRGB(data: tuple!.pointer, totalBytes: tuple!.numberOfBytes)
        
        let key = RGB(red: 0.0, green: 0.0, blue: 0.0)
        let keys = RGBMap.keys
        XCTAssert(keys.contains(key))
        XCTAssertEqual(RGBMap[key], 2)
    }
    
    func testConvertPixelstoRGBContainsWhite() {
        let tuple = testImagePerfect().pixels()
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let RGBMap = quantizer.convertPixelsToRGB(data: tuple!.pointer, totalBytes: tuple!.numberOfBytes)
        
        let key = RGB(red: 0.0, green: 0.0, blue: 0.0)
        let keys = RGBMap.keys
        XCTAssert(keys.contains(key))
        XCTAssertEqual(RGBMap[key], 2)
    }
    
    func testConvertPixelstoRGBContainsGreen() {
        let tuple = testImagePerfect().pixels()
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let RGBMap = quantizer.convertPixelsToRGB(data: tuple!.pointer, totalBytes: tuple!.numberOfBytes)
        
        let key = RGB(red: 0.0, green: 0.0, blue: 0.0)
        let keys = RGBMap.keys
        XCTAssert(keys.contains(key))
        XCTAssertEqual(RGBMap[key], 2)
    }
    
    func testConvertPixelstoRGBContainsRed() {
        let tuple = testImagePerfect().pixels()
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let RGBMap = quantizer.convertPixelsToRGB(data: tuple!.pointer, totalBytes: tuple!.numberOfBytes)
        
        let key = RGB(red: 0.0, green: 0.0, blue: 0.0)
        let keys = RGBMap.keys
        XCTAssert(keys.contains(key))
        XCTAssertEqual(RGBMap[key], 2)
    }
    
    func testSamplePixelsNoFilterBlack() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssert(samples.contains(ColorInformation(color: UIColor.black, population: 1)))
    }
    
    func testSamplePixelsFilterBlack() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [BlockBlack()], paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssertFalse(samples.contains(ColorInformation(color: UIColor.black, population: 1)))
    }
    
    func testSamplePixelsNoFilterWhite() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssert(samples.contains(ColorInformation(color: UIColor.white, population: 1)))
    }
    
    func testSamplePixelsFilterWhite() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [BlockWhite()], paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssertFalse(samples.contains(ColorInformation(color: UIColor.white, population: 1)))
    }
    
    func testSamplePixelsNoFilterRed() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssert(samples.contains(ColorInformation(color: UIColor.red, population: 1)))
    }
    
    func testSamplePixelsFilterRed() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [BlockRed()], paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssertFalse(samples.contains(ColorInformation(color: UIColor.red, population: 1)))
    }
    
    func testSamplePixelsNoFilterGreen() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [Filter](), paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssert(samples.contains(ColorInformation(color: UIColor.green, population: 1)))
    }
    
    func testSamplePixelsFilterGreen() {
        let RGBMap = [RGB(red: 0, green: 0, blue: 0) : 1, RGB(red: 1, green: 1, blue: 1) : 1, RGB(red: 1, green: 0, blue: 0) : 1, RGB(red: 0, green: 1, blue: 0) : 1]
        
        let quantizer = Quantizer(image: testImage2By(), filters: [BlockGreen()], paletteSize: .Default)
        let samples = quantizer.samplePixels(RGBMap: RGBMap)
        XCTAssertFalse(samples.contains(ColorInformation(color: UIColor.green, population: 1)))
    }
}
