//  TestImageSupport.swift
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

import Foundation
import UIKit

@testable import ColorPal

func testImagePerfect() -> UIImage {
    return TestImageSupport.testImageWithColors(colors: idealVibrantColor, minimumVibrantColor, maximumVibrantColor, idealMutedColor, minimumMutedColor, maximumMutedColor, idealLightVibrantColor, minimumLightVibrantColor, maximumLightVibrantColor, idealLightMutedColor, minimumLightMutedColor, maximumLightMutedColor, idealDarkVibrantColor, minimumDarkVibrantColor, maximumDarkVibrantColor, idealDarkMutedColor, minimumDarkMutedColor, maximumDarkMutedColor)
}

func testImage2By() -> UIImage {
    return TestImageSupport.testImageWithColors(colors: UIColor.red, UIColor.white, UIColor.black, UIColor.green)
}

func testImage1By() -> UIImage {
    return TestImageSupport.testImageWithColors(colors: UIColor.white)
}

let idealVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.5))
let minimumVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.3))
let maximumVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.7))

let idealMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.5))
let minimumMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.3))
let maximumMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 0.7))

let idealLightVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.74))
let minimumLightVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.55))
let maximumLightVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 1.0))

let idealLightMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.74))
let minimumLightMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.55))
let maximumLightMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 1.0))

let idealDarkVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.26))
let minimumDarkVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.35, luminance: 0.0))
let maximumDarkVibrantColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 1.0, luminance: 0.45))

let idealDarkMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.3, luminance: 0.26))
let minimumDarkMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.0, luminance: 0.0))
let maximumDarkMutedColor = UIColor(HSLValue: HSL(hue: 1.0, saturation: 0.4, luminance: 0.45))

class TestImageSupport {
    static func testImageWithColors(colors: UIColor...) -> UIImage {
        let colorCount = colors.count
        let sideSize = findNearestRoot(number: colorCount)
        let pixelCount = sideSize * sideSize
        
        let imageRect = CGRectMake(0, 0, CGFloat(sideSize), CGFloat(sideSize))
        
        UIGraphicsBeginImageContext(imageRect.size)
        
        var paddedColors = colors
        let paddedColorCount = pixelCount - colorCount
        if paddedColorCount > 0 {
            paddedColors.append(contentsOf: colors.prefix(paddedColorCount))
        }
        
        for i in 0..<pixelCount {
            let col = i % sideSize
            let row = i / sideSize
            paddedColors[i].set()
            UIRectFill(CGRectMake(CGFloat(row), CGFloat(col), 1, 1))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    private static func findNearestRoot(number: Int) -> Int {
        let root = sqrt(Double(number))
        let ceiling = ceil(root)
        
        return Int(ceiling)
    }

}

    
