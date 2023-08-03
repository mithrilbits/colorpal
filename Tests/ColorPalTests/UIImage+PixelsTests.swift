//  UIImage+PixelsTests.swift
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

class UIImage_PixelsTests: XCTestCase {
    var image: UIImage!
    
    let pixelData: [UInt8] = [255, 0, 0, 255, 0, 0, 255, 255, 255, 255, 255, 255, 0, 0, 0, 255]
    
    override func setUp() {
        image = TestImageSupport.testImageWithColors(colors: UIColor.red, UIColor.white, UIColor.blue, UIColor.black)
    }
    
    override func tearDown() {
        image = nil
    }
    
    func testPixelsBytesCorrect() {
        let pixels = image.pixels()
        let pointer = pixels?.pointer
        let byteCount = pixels?.numberOfBytes
        
        var bytes = [UInt8]()
        for i in 0..<(byteCount ?? 0) {
            bytes.append(pointer?[i] ?? 0)
        }
        
        XCTAssertEqual(bytes, pixelData)
    }
    
    func testPixelsByteCountCorrect() {
        let pixels = image.pixels()
        let byteCount = pixels!.numberOfBytes
        
        XCTAssertEqual(byteCount, 2 * 2 * 4) // Width, Height, Number of bytes per pixel
    }
}
