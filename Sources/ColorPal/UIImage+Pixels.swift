//  UIImage+Pixels.swift
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
     Get individual pixels from this UIImage object.
     
     Before getting the backing memory for the image, we draw it to an ARGB Bitmap Context so that we can convert the
     memory backing the UIImage to RGB pixels. Our quantizer will assume the pixels will all be in the RGB color
     space.
     
     - returns: A tuple containing an unsafe pointer to a memory location containing consecutive UInt8 values that represent individual pixels and the number of bytes of which the image consists
     */
    func pixels() -> (pointer: UnsafeMutablePointer<UInt8>, numberOfBytes: Int)? {
        guard let tuple = createARGBBitmapContext() else {
            return nil
        }
        
        let pixelsWide = size.width
        let pixelsHigh = size.height
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        tuple.context.draw(cgImage, in: rect)
        
        guard let data = tuple.context.data else {
            return nil
        }
        
        return (data.bindMemory(to: UInt8.self, capacity: tuple.numberOfBytes), tuple.numberOfBytes)
    }
    
    /**
     Get an ARGB Bitmap context.
     
     We will use this bitmap context to standardize the color space of the UIImage before getting the individual
     pixels from memory.
     
     - returns: A tuple containing the ARGB context and the number of bytes of which the image consists
     */
    private func createARGBBitmapContext() -> (context: CGContext, numberOfBytes: Int)? {
        guard let image = self.cgImage else {
                print("Error getting CGImage from UIImage.")
                return nil
            }
            
            let pixelsWide = image.width
            let pixelsHigh = image.height
            
            let bitmapBytesPerRow = Int(pixelsWide) * 4
            let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let bitmapData = calloc(bitmapByteCount, MemoryLayout<UInt8>.size)
            
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            guard let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
                print("Error generating CGContext")
                free(bitmapData)
                return nil
            }
            
            return (context, bitmapByteCount)
    }
}
