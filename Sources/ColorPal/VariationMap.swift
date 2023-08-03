//  VariationMap.swift
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

// MARK: - VariationMap protocol
/**
 A protocol that defines a standard means of determining the main six color variations of a palette.
 */
public protocol VariationMap {
    /**
     The sample which this map considers to be vibrant (or nil if it doesn't exist)
     */
    var vibrantSample: Sample? { get }
    /**
     The sample which this map considers to be muted (or nil if it doesn't exist)
     */
    var mutedSample: Sample? { get }
    /**
     The sample which this map considers to be light vibrant (or nil if it doesn't exist)
     */
    var lightVibrantSample: Sample? { get }
    /**
     The sample which this map considers to be light muted (or nil if it doesn't exist)
     */
    var lightMutedSample: Sample? { get }
    /**
     The sample which this map considers to be dark vibrant (or nil if it doesn't exist)
     */
    var darkVibrantSample: Sample? { get }
    /**
     The sample which this map considers to be dark muted (or nil if it doesn't exist)
     */
    var darkMutedSample: Sample? { get }
    
    /**
     Map an array of samples to the variations.
     
     - parameter samples: An array of samples to be considered
     */
    func map(samples: [Sample]?)
}

public class DefaultVariationMap: VariationMap {
    /**
     Implementation of the VariationMap protocol
     */
    public var vibrantSample: Sample?
    /**
     Implementation of the VariationMap protocol
     */
    public var mutedSample: Sample?
    /**
     Implementation of the VariationMap protocol
     */
    public var lightVibrantSample: Sample?
    /**
     Implementation of the VariationMap protocol
     */
    public var lightMutedSample: Sample?
    /**
     Implementation of the VariationMap protocol
     */
    public var darkVibrantSample: Sample?
    /**
     Implementation of the VariationMap protocol
     */
    public var darkMutedSample: Sample?
    
    /**
     Implementation of the VariationMap protocol
     
     - parameter samples: An array of samples to be considered
     */
    public func map(samples: [Sample]?) {
        mapColorVariations(samples: samples)
        generateMissingColorVariations()
    }
    
    /**
     Attempt to map the samples to the default ColorVariations
     
     - parameter samples: The samples to be considered
     */
    func mapColorVariations(samples: [Sample]?) {
        guard let samples = samples else {
            return
        }
        
        var mutableSamples = samples
        
        if let sample = locateBestMatch(for: .vibrantVariation, in: mutableSamples) {
            vibrantSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
        
        if let sample = locateBestMatch(for: .lightVibrantVariation, in: mutableSamples) {
            lightVibrantSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
        
        if let sample = locateBestMatch(for: .darkVibrantVariation, in: mutableSamples) {
            darkVibrantSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
        
        if let sample = locateBestMatch(for: .mutedVariation, in: mutableSamples) {
            mutedSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
        
        if let sample = locateBestMatch(for: .lightMutedVariation, in: mutableSamples) {
            lightMutedSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
        
        if let sample = locateBestMatch(for: .darkMutedVariation, in: mutableSamples) {
            darkMutedSample = sample
            if let index = mutableSamples.firstIndex(of: sample) {
                mutableSamples.remove(at: index)
            }
        }
    }
    
    private func locateBestMatch(for variation: ColorVariation, in samples: [Sample]) -> Sample? {
        return variation.locateBestMatch(samples: samples)
    }
    
    /**
     Generate a vibrant sample if we have a dark vibrant sample (with no vibrant sample), or generate a dark vibrant sample if we have a vibrant sample (with no dark vibrant sample).
     */
    func generateMissingColorVariations() {
        if vibrantSample == nil {
            if let darkVibrantSample = darkVibrantSample {
                let darkVibrantHSL = darkVibrantSample.HSLValue
                let HSLValue = HSL(hue: darkVibrantHSL.hue, saturation: darkVibrantHSL.saturation, luminance: 0.5)
                vibrantSample = Sample(color: UIColor(HSLValue: HSLValue), population: 0)
            }
        }
        
        if darkVibrantSample == nil {
            if let vibrantSample = vibrantSample {
                let darkVibrantHSL = vibrantSample.HSLValue
                let HSLValue = HSL(hue: darkVibrantHSL.hue, saturation: darkVibrantHSL.saturation, luminance: 0.26)
                darkVibrantSample = Sample(color: UIColor(HSLValue: HSLValue), population: 0)
            }
        }
    }
}
