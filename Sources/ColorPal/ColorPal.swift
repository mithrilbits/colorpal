//  ColorPal.swift
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

// MARK: - ColorPal struct

/**
    A palette of colors sampled from a UIImage.
*/
public struct ColorPal {
    /**
        The maximum width or height of a sampled image in pixels. 
     
        If an image is larger than this number on its largest dimension, it will be resized.
    */
    private static let maxBitmapDimensionForSampledImage = 192
    /**
        An object to match samples to ColorVariations
    */
    private let variationMap: VariationMap
    /**
        An array of samples representing the color values sampled from the source image
    */
    public let samples: [Sample]?
    /**
        The sample object (if any) most closely resembling the vibrant ColorVariation.
    */
    public var vibrantSample: Sample? {
        return variationMap.vibrantSample
    }
    /**
        The sample object (if any) most closely resembling the muted ColorVariation.
    */
    public var mutedSample: Sample? {
        return variationMap.mutedSample
    }
    /**
        The sample object (if any) most closely resembling the light vibrant ColorVariation.
    */
    public var lightVibrantSample: Sample? {
        return variationMap.lightVibrantSample
    }
    /**
        The sample object (if any) most closely resembling the light muted ColorVariation.
    */
    public var lightMutedSample: Sample? {
        return variationMap.lightMutedSample
    }
    /**
        The sample object (if any) most closely resembling the dark vibrant ColorVariation.
    */
    public var darkVibrantSample: Sample? {
        return variationMap.darkVibrantSample
    }
    /**
        The sample object (if any) most closely resembling the dark muted ColorVariation.
    */
    public var darkMutedSample: Sample? {
        return variationMap.darkMutedSample
    }
    
    /**
        Initialize a new palette object from a source image.
     
        - warning: Initialization includes resizing, sampling, and mapping color samples on the main thread.
        Obviously this class should never be initialized on the main thread. Consider using a ColorPal.async() method
        instead.
     
        - parameter image: A UIImage object to be sampled
    */
    public init(image: UIImage) {
        self.init(image: image, filters: [DefaultFilter()], map: DefaultVariationMap(), paletteSize: .Default)
    }
    
    /**
        Initialize a new palette object from a source image.
     
        - warning: Initialization includes resizing, sampling, and mapping color samples on the main thread.
        Obviously this class should never be initialized on the main thread Consider using a ColorPal.async() method
        instead.
     
        - parameter image:          A UIImage object to be sampled
        - parameter filters:        A set of filters to disallow certain colors
        - parameter map:            An object that maps Samples to ColorVariations
        - parameter paletteSize:    An enum that indicates the number of colors the palette should contain
    */
    public init(image: UIImage, filters: [Filter], map: VariationMap, paletteSize: PaletteSize) {
        self.variationMap = map
        
        // Resize image so that we aren't operating on too large of an image
        let resizedImage = image.resizeToMaxDimension(desiredDimension: ColorPal.maxBitmapDimensionForSampledImage)
        
        guard let resizedImage = resizedImage else {
            print("Error resizing image. Cannot generate color palette")
            samples = []
            return
        }
        
        // Quantize the pixels into a finite list of samples
        let quantizer = Quantizer(image: resizedImage, filters: filters, paletteSize: paletteSize)
        samples = quantizer.samples
        
        // Map samples
        self.variationMap.map(samples: samples)
    }
}

// MARK: - ColorPal asynchronous methods
extension ColorPal {
    /**
        Generate a ColorPal object on a background thread.
     
        The completion block will be invoked on the main thread once initialization of the ColorPal object is
        complete.
     
        - parameter image:      A UIImage object to be sampled
        - parameter completion: A completion handler block to be invoked on the main thread once initialization is 
        complete
    */
    public static func async(image: UIImage, completion: @escaping (ColorPal) -> Void) {
        async(image: image, filters: [DefaultFilter()], map: DefaultVariationMap(), paletteSize: .Default, completion: completion)
    }
    
    /**
        Generate a ColorPal object on a background thread.
     
        The completion block will be invoked on the main thread once initialization of the ColorPal object is
        complete.
     
        - parameter image:          A UIImage object to be sampled
        - parameter filters:        A set of filters to disallow certain colors
        - parameter map:            An object that maps Samples to ColorVariations
        - parameter paletteSize:    An enum that indicates the number of colors the palette should contain
        - parameter completion:     A completion handler block to be invoked on the main thread once initialization is
        complete
    */
    public static func async(image: UIImage, filters: [Filter], map: VariationMap, paletteSize: PaletteSize, completion: @escaping (ColorPal) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let palette = ColorPal(image: image, filters: filters, map: map, paletteSize: paletteSize)
            DispatchQueue.main.async {
                completion(palette)
            }
        }
    }
}

// MARK: - ColorPal convenience methods
extension ColorPal {
    /**
        Get the vibrant sample color or a default if it is undefined.
     
        - parameter color: A default value if the vibrant sample is undefined
     
        - returns: The vibrant sample color a default value if it is undefined
    */
    public func vibrantSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: vibrantSample, color: color)
    }
    /**
        Get the muted sample color or a default if it is undefined.
     
        - parameter color: A default value if the muted sample is undefined
     
        - returns: The muted sample color a default value if it is undefined
    */
    public func mutedSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: mutedSample, color: color)
    }
    /**
        Get the light vibrant sample color or a default if it is undefined.
     
        - parameter color: A default value if the light vibrant sample is undefined
     
        - returns: The light vibrant sample color a default value if it is undefined
    */
    public func lightVibrantSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: lightVibrantSample, color: color)
    }
    /**
        Get the light muted sample color or a default if it is undefined.
     
        - parameter color: A default value if the light muted sample is undefined
     
        - returns: The light muted sample color a default value if it is undefined
    */
    public func lightMutedSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: lightMutedSample, color: color)
    }
    /**
        Get the dark vibrant sample color or a default if it is undefined.
     
        - parameter color: A default value if the dark vibrant sample is undefined
     
        - returns: The dark vibrant sample color a default value if it is undefined
    */
    public func darkVibrantSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: darkVibrantSample, color: color)
    }
    /**
        Get the dark muted sample color or a default if it is undefined.
     
        - parameter color: A default value if the dark muted sample is undefined
     
        - returns: The dark muted sample color a default value if it is undefined
    */
    public func darkMutedSampleColorWithDefault(color: UIColor) -> UIColor {
        return sampleColorWithDefault(sample: darkMutedSample, color: color)
    }
    
    /**
        Determine if a given sample is nil. If it is not, return its color value, otherwise return a default color.
     
        - parameter sample: The sample whose color we want (if it isn't nil)
        - parameter color:  A default color value if the sample is nil
     
        - returns: Either the sample color or a default color if the sample is nil
    */
    private func sampleColorWithDefault(sample: Sample?, color: UIColor) -> UIColor {
        if let sample = sample {
            return sample.uiColor
        }
        return color
    }
}
