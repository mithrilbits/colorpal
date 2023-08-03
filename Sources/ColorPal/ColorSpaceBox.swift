//  ColorSpaceBox.swift
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

// MARK: - ColorSpaceBox class

/**
 A class that encapsulates a range of colors.
 
 A box can be split into two boxes along its longest dimension (red, green, or blue) provided the box contains at
 least two separate colors.
 
 The box can also provide an average color that is representative of all of the colors that it contains.
 */
class ColorSpaceBox {
    /**
     The ColorInformation objects covered by this ColorSpaceBox
     */
    private(set) var samples: [ColorInformation]
    /**
     The minimum red value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var minRed: CGFloat = 0
    /**
     The maximum red value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var maxRed: CGFloat = 0
    /**
     The minimum green value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var minGreen: CGFloat = 0
    /**
     The maximum green value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var maxGreen: CGFloat = 0
    /**
     The minimum blue value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var minBlue: CGFloat = 0
    /**
     The maximum blue value (between 0.0 and 1.0) covered by this ColorSpaceBox
     */
    private var maxBlue: CGFloat = 0
    
    /**
     Initialize a new ColorSpaceBox.
     
     - parameter samples: An array of color samples that will make up the box's colors.
     */
    required init(samples: [ColorInformation]) {
        self.samples = samples
        fillAndSort()
    }
}

// MARK: - ColorSpaceBox size calculated properties
extension ColorSpaceBox {
    /**
     The dimension (red, green, or blue) that covers the largest volume (difference between max value and min
     value) in this ColorSpaceBox.
     */
    var longestDimension: ColorSpaceBoxDimension {
        let redLength = maxRed - minRed
        let greenLength = maxGreen - minGreen
        let blueLength = maxBlue - minBlue
        
        if redLength > greenLength && redLength > blueLength {
            return .Red
        }
        if greenLength > redLength && greenLength > blueLength {
            return .Green
        }
        return .Blue
    }
    
    /**
     A rating between 1 and 8 that represents how much of the color spectrum this box covers.
     
     If this box contains only a single color, the value will be 1.
     
     If this box contains *EVERY* color, the value will be 8.
     */
    var volume: CGFloat {
        return (maxRed - minRed + 1) * (maxGreen - minGreen + 1) * (maxBlue - minBlue + 1)
    }
    
    /**
     Indicates whether this box is capable of splitting into two separate boxes.
     */
    var canSplit: Bool {
        return samples.count > 1
    }
    
    /**
     The color value that is exactly between the max and min color values along the box's longest dimension.
     */
    var middleDimensionValue: CGFloat {
        switch longestDimension {
        case .Red:
            return (minRed + maxRed) / 2
        case .Green:
            return (minGreen + maxGreen) / 2
        case .Blue:
            return (minBlue + maxBlue) / 2
        }
    }
    
    /**
     The index of the first item in the samples array that has a color dimension value higher than the box's
     middleDimensionValue along the box's longestDimension.
     
     This is primarily used to determine how to split the box into two separate boxes such that each box contains
     approximately half of all the color volume represented by the original box.
     
     - warning: This property is implemented under the assumption that the samples in the samples array will always be
     sorted ascending by the sample's dimension value along the box's longest dimension.
     
     This property does not perform the sort each time it is evaluated for performance reasons. The sort happens
     inside the fillAndSort() method.
     */
    var sampleSplitIndex: Int? {
        for (index, sample) in samples.enumerated() {
            let rgb = sample.color.RGBValue
            
            switch longestDimension {
            case .Red:
                if rgb.red >= middleDimensionValue {
                    return index
                }
            case .Green:
                if rgb.green >= middleDimensionValue {
                    return index
                }
            case .Blue:
                if rgb.blue >= middleDimensionValue {
                    return index
                }
            }
        }
        return nil
    }
}

// MARK: - ColorSpaceBox methods
extension ColorSpaceBox {
    /**
     Calculate an average color based on all of the samples included in this box.
     
     The average is calculated by creating an average of all the red values, the green values, and the blue values of
     the samples weighted by the population of each sample.
     
     The averages are then turned into a sample object using the average color and the sum of all the populations
     covered by this box.
     
     - returns: A sample object representing the average color.
     */
    func averageColor() -> Sample {
        var redSum: CGFloat = 0
        var greenSum: CGFloat = 0
        var blueSum: CGFloat = 0
        var totalPopulation: Int = 0
        
        for sample in samples {
            let rgb = sample.color.RGBValue
            
            totalPopulation += sample.population
            redSum += CGFloat(sample.population) * rgb.red
            greenSum += CGFloat(sample.population) * rgb.green
            blueSum += CGFloat(sample.population) * rgb.blue
        }
        
        let redAverage: CGFloat = redSum / CGFloat(totalPopulation)
        let greenAverage: CGFloat = greenSum / CGFloat(totalPopulation)
        let blueAverage: CGFloat = blueSum / CGFloat(totalPopulation)
        
        return Sample(color: UIColor(red: redAverage, green: greenAverage, blue: blueAverage, alpha: 1.0), population: totalPopulation)
    }
    
    /**
     Create a new ColorSpaceBox covering approximately half of the color volume covered by this ColorSpaceBox.
     
     The sampleSplitIndex will determine which samples are moved to the new ColorSpaceBox and which samples stay with
     the current ColorSpaceBox. The samples covered by the new ColorSpaceBox will be removed from the samples array in
     the current ColorSpaceBox.
     
     - note: The split method will cause the current ColorSpaceBox to invoke fillAndSort(). This is because the
     removal of half the color volume may change the current box's longest dimension.
     
     - returns: A new ColorSpaceBox which covers half of the samples previously covered by the current ColorSpaceBox
     or nil if the current box cannot split or a sampleSplitIndex cannot be determined.
     */
    func split() -> ColorSpaceBox? {
            if !canSplit {
                return nil
            }
            var newBox: ColorSpaceBox? = nil
            
            if let sampleSplitIndex = sampleSplitIndex {
                newBox = ColorSpaceBox(samples: Array(samples.suffix(from: sampleSplitIndex)))
                samples.removeSubrange(sampleSplitIndex..<samples.count)
            }
            fillAndSort()
            
            return newBox
        }
    
    /**
     Determine new values for the min and max red, green, and blue values and sort the color samples around the box's
     longest dimension.
     
     For example, if the longest dimension is green, sort the samples ascending by each sample's green value.
     */
    private func fillAndSort() {
            minRed = 1
            minGreen = 1
            minBlue = 1
            
            maxRed = 0
            maxGreen = 0
            maxBlue = 0
            
            for sample in samples {
                let rgb = sample.color.RGBValue
                
                if rgb.red > maxRed {
                    maxRed = rgb.red
                }
                if rgb.red < minRed {
                    minRed = rgb.red
                }
                if rgb.green > maxGreen {
                    maxGreen = rgb.green
                }
                if rgb.green < minGreen {
                    minGreen = rgb.green
                }
                if rgb.blue > maxBlue {
                    maxBlue = rgb.blue
                }
                if rgb.blue < minBlue {
                    minBlue = rgb.blue
                }
            }
            
            samples.sort {
                let rgb0 = $0.color.RGBValue
                let rgb1 = $1.color.RGBValue
                
                switch longestDimension {
                case .Red:
                    return rgb0.red < rgb1.red
                case .Green:
                    return rgb0.green < rgb1.green
                case .Blue:
                    return rgb0.blue < rgb1.blue
                }
            }
        }
}

// MARK: - ColorSpaceBox implementation of Comparable
extension ColorSpaceBox : Comparable {}

/**
 Determine how two ColorSpaceBoxes should be sorted.
 
 - parameter lhs: The first ColorSpaceBox in the evaluation.
 - parameter rhs: The second ColorSpaceBox in the evaluation.
 
 - returns: A bool indicating whether rhs has a larger volume than lhs
 */
func <(lhs: ColorSpaceBox, rhs: ColorSpaceBox) -> Bool {
    return lhs.volume < rhs.volume
}

/**
 Determine if two ColorSpaceBoxes are equal.
 
 - parameter lhs: The first ColorSpaceBox in the evaluation.
 - parameter rhs: The second ColorSpaceBox in the evaluation.
 
 - returns: A bool indicating whether lhs and rhs have the same samples array
 */
func ==(lhs: ColorSpaceBox, rhs: ColorSpaceBox) -> Bool {
    return lhs.samples == rhs.samples
}

// MARK: - ColorSpaceBoxDimension

/**
 An enum encapsulating the three dimensions of an RGB color.
 */
enum ColorSpaceBoxDimension {
    case Red
    case Green
    case Blue
}
