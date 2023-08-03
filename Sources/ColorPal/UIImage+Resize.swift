//  UIImage+Resize.swift
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

extension UIImage {
    /**
        Resize such that our largest dimension (width or height) is no larger than the desired dimension.
     
        If we are already smaller than the desiredDimension, just return self.
     
        - parameter desiredDimension: The max size in pixels of the largest dimension of the UIImage
     
        - returns: A UIImage that has been resized
    */
    func resizeToMaxDimension(desiredDimension: Int) -> UIImage? {
        let maxDimension = Int(max(size.width, size.height))
        
        if maxDimension <= desiredDimension {
            return self
        }
        let scaleRatio = (CGFloat(desiredDimension) / CGFloat(maxDimension))
        return scale(scaleRatio: scaleRatio)
    }
    
    /**
        Resize according to a scale ratio maintaining aspect ratio.
     
        - parameter scaleRatio: The ratio to which this image should be scaled
     
        - returns: A UIImage that has been resized
     */
    func scale(scaleRatio: CGFloat) -> UIImage? {
        let newSize = CGSizeMake(size.width * scaleRatio, size.height * scaleRatio)
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
