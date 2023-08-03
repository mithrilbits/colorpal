//  TestFilters.swift
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

class BlockBlack: Filter {
    func isAllowed(color: UIColor) -> Bool {
        return color.RGBValue != UIColor.black.RGBValue
    }
}

class BlockWhite: Filter {
    func isAllowed(color: UIColor) -> Bool {
        return color.RGBValue != UIColor.white.RGBValue
    }
}

class BlockRed: Filter {
    func isAllowed(color: UIColor) -> Bool {
        return color.RGBValue != UIColor.red.RGBValue
    }
}

class BlockGreen: Filter {
    func isAllowed(color: UIColor) -> Bool {
        return color.RGBValue != UIColor.green.RGBValue
    }
}
