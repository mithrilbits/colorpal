//  Quantizer.swift
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

// MARK: - Quantizer struct
/**
 A struct to convert a UIImage into an array of Sample objects.
 */
struct Quantizer {
    /**
     An array of filter objects to filter ineligible samples from the palette
     */
    let filters: [Filter]
    /**
     A (publicly) read-only array of Samples determined from a UIImage
     
     - note: We use this funky property declaration style because we need to initialize this object using method calls
     within the initializer. This is basically a hack around the compiler. It publicly equates to "let samples:
     [Sample]"
     */
    private(set) var samples: [Sample]?
    
    /**
     Initialize a new quantizer object.
     
     - note: This initializer is potentially slow since it does all of the work of quantizing the UIImage as part of
     object initialization.
     
     The quantizer converts the UIImage into pixels. It then creates an RGB object for each pixel. Those RGB objects
     that are not disallowed by a filter are converted to Sample objects. Finally, it averages the samples together
     until the number of samples is equal to or less than the maximum number of samples indicatd by paletteSize.
     
     - parameter image:          The UIImage to be sampled
     - parameter filters:        An array of Filter objects to determine what colors are permissible
     - parameter paletteSize:    An indicator of many distinct samples should be captured in the palette
     */
    init(image: UIImage, filters: [Filter], paletteSize: PaletteSize) {
        self.filters = filters
        
        guard let tuple = image.pixels() else {
            samples = []
            return
        }
        
        let RGB = convertPixelsToRGB(data: tuple.pointer, totalBytes: tuple.numberOfBytes)
        let unquantizedSamples = samplePixels(RGBMap: RGB)
        samples = quantizeSamples(samples: unquantizedSamples, paletteSize: paletteSize)
    }
}

// MARK: - Quantizer sampling methods
extension Quantizer {
    /**
     Converts pixels into RGB objects while tracking the number of times a single RGB value appears in the collection
     of pixels.
     
     - parameter data:       An unsafe pointer to a memory location containing consecutive UInt8 values that represent
     individual pixels
     - parameter totalBytes: The total number of bytes contained in the UIImage
     
     - returns: A dictionary whose keys are the individual RGB values and whose values are the population values for
     the given RGB key.
     */
    func convertPixelsToRGB(data: UnsafePointer<UInt8>, totalBytes: Int) -> [RGB: Int] {
        var results = [RGB: Int]()
        
        // Each pixel is represented by 4 bytes, so stride through the data in increments of 4
        for i in stride(from: 0, through: totalBytes - 4, by: 4) {
            let r = CGFloat(data[i]) / 255.0
            let g = CGFloat(data[i + 1]) / 255.0
            let b = CGFloat(data[i + 2]) / 255.0
            //        let a = CGFloat(data[i + 3]) / 255.0
            
            let key: RGB = RGB(red: r, green: g, blue: b)
            
            // If the RGB value has already been seen before, update its population value in the dictionary
            results[key, default: 0] += 1
        }
        
        return results
    }
    
    /**
     Convert any RGB objects that are not excluded by filters into ColorInformation objects.
     
     - note: We use ColorInformation objects here instead of Samples because they do not compute text color values as
     part of their initialization like regular Sample objects do. Calculating those values would incur a significant
     performance hit.
     */
    func samplePixels(RGBMap: Dictionary<RGB, Int>) -> [ColorInformation] {
        var samples = [ColorInformation]()
        
        for key in RGBMap.keys {
            if !shouldIgnoreColor(RGBValue: key) {
                let color = UIColor(red: CGFloat(key.red), green: CGFloat(key.green), blue: CGFloat(key.blue), alpha: 1.0)
                let sample = ColorInformation(color: color, population: RGBMap[key]!)
                samples.append(sample)
            }
        }
        return samples
    }
}

// MARK: - Quantizer quantization methods
extension Quantizer {
    /**
     Average samples together until the total number of samples is less than or equal to the desired palette size.
     
     If we have more Samples than the request palette size, this method will use ColorSpace boxes to average the
     samples together until we reach the appropriate palette size.
     
     - parameter samples:        The samples to be averaged
     - parameter paletteSize:    Indicator of desired palette size
     
     - returns: An array of samples whose size is less than or equal to the desired palette size
     */
    func quantizeSamples(samples: [ColorInformation], paletteSize: PaletteSize) -> [Sample] {
        var maximumNumberOfColors: Int
        switch (paletteSize) {
        case .Micro:
            maximumNumberOfColors = 2
        case .Small:
            maximumNumberOfColors = 8
        case .Default:
            maximumNumberOfColors = 16
        case .Large:
            maximumNumberOfColors = 24
        }
        
        // If the number of samples is already less than or equal to maximum number of colors, just return them
        if samples.count <= maximumNumberOfColors {
            return convertColorInformationToFull(samples: samples)
        }
        
        // Otherwise
        // Put the samples into a single color space box
        var boxes = [ColorSpaceBox(samples: samples)]
        
        // Split the boxes until they can either split no further, or we have the same number of boxes as we have maximum
        // colors
        while boxes.count < maximumNumberOfColors {
            let box = boxes.first!
            let newBox = box.split()
            boxes.append(newBox!)
            // Sort the boxes with descending order of volume so that the biggest volume box gets split next.
            boxes.sort {
                return $0 > $1
            }
        }
        
        // Get an average color (sample) from each box and return them
        var samples = [Sample]()
        for box in boxes {
            let sample = box.averageColor()
            samples.append(sample)
        }
        return samples
    }
}


// MARK: - Quantizer utility methods
extension Quantizer {
    /**
     Determine if the given color is excluded by any of our filters.
     
     - parameter color: The color being evaluated
     
     - returns: A Bool indicating whether the color should be excluded
     */
    func shouldIgnoreColor(color: UIColor) -> Bool {
        for filter in filters {
            if !filter.isAllowed(color: color) {
                return true
            }
        }
        return false
    }
    
    /**
     Determine if the given RGB value is excluded by any of our filters.
     
     - parameter RGBValue: The RGB value being evaluated
     
     - returns: A Bool indicating whether the value should be excluded
     */
    func shouldIgnoreColor(RGBValue: RGB) -> Bool {
        return shouldIgnoreColor(color: UIColor(red: CGFloat(RGBValue.red), green: CGFloat(RGBValue.green), blue: CGFloat(RGBValue.blue), alpha: 1.0))
    }
    
    /**
     A convenience method to convert an array of IntermediateSamples into an array of full Samples.
     
     - parameter samples: The array of IntermediateSamples to be converted
     
     - returns: An array of full Samples created from the array of IntermediateSamples
     */
    private func convertColorInformationToFull(samples: [ColorInformation]) -> [Sample] {
        var fullSamples = [Sample]()
        for intermediate in samples {
            fullSamples.append(Sample(sample: intermediate))
        }
        return fullSamples
    }
}

// MARK: - PaletteSize

/**
 An enum indicating the desired number of samples to be included in a palette.
 */
public enum PaletteSize {
    case Micro // This is mostly for testing purposes
    case Small // This is a very low resolution palette. Most colors will be averaged together.
    case Default // This is good for landscapes
    case Large // This is good for faces
}
