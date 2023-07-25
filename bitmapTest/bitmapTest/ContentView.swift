//
//  ContentView.swift
//  bitmapTest
//
//  Created by Aaron Beckley on 7/24/23.
//

import SwiftUI
//import Numerics
import ComplexModule //complex



class traverse {
    
    func drawPoint(width: Int, height: Int, x: Int, y: Int, pixels: Array<PixelData>, color: UInt8) -> Array<PixelData> {
        var maxY = 0
        if y >= 10 {
            maxY = height
            while (maxY % height != maxY) && (maxY * maxY <= height) {
                maxY = maxY / 10
            }
        } else {
            maxY = height
        }
        if y > maxY {
            print("Cannot change value, y out of range")
            return pixels
        }
        
        if x > width {
            print("Cannot change value, x out of range")
            return pixels
        }
        if Int(x*width+y) > (width*height)-1 {
            print("Out of range, too large")
            return pixels
        }
        var newpixels = pixels
        
        newpixels[Int(x*width+y)].a = 255
        newpixels[Int(x*width+y)].r = color
        newpixels[Int(x*width+y)].g = color
        newpixels[Int(x*width+y)].b = color
        //print("test")
        return newpixels
    }
    
    func MakePointBlack(width: Int, height: Int, x: Int, y: Int, pixels: Array<PixelData>) -> Array<PixelData> {
        var maxY = 0
        if y >= 10 {
            maxY = height
            while (maxY % height != maxY) && (maxY * maxY <= height) {
                maxY = maxY / 10
            }
        } else {
            maxY = height
        }
        if y > maxY {
            print("Cannot change value, y out of range")
            return pixels
        }
        
        if x > width {
            print("Cannot change value, x out of range")
            return pixels
        }
        if Int(y*height+x) > (width*height)-1 {
            print("Out of range, too large")
            return pixels
        }
        var newpixels = pixels
        
        newpixels[Int(y*height+x)].a = 255
        newpixels[Int(y*height+x)].r = 0
        newpixels[Int(y*height+x)].g = 0
        newpixels[Int(y*height+x)].b = 0
        //print("test")
        return newpixels
    }
}

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
    
    
    
}





struct ContentView: View {
    
    @State var image: UIImage = UIImage(named: "screenie")!
    @State var finished = false
    func oldOnappear() {
        let height = 1000
        let width = 1000
        var x = 0 //is width
        var y = 0 //is height
        
        //get cordinate points from w and h
        
        var pixels: [PixelData] = .init(repeating: .init(a: 0, r: 0, g: 0, b: 0), count: width * height)
        /*
        for index in pixels.indices {
            pixels[index].a = 255
            pixels[index].r = .random(in: 0...255)
            pixels[index].g = .random(in: 0...255)
            pixels[index].b = .random(in: 0...255)
        }
         */
        for index in pixels.indices {
         
                pixels[index].a = 255
                pixels[index].r = 255
                pixels[index].g = 255
                pixels[index].b = 255
            
        }
        var pixels2 = pixels
        while (y*height+x) < pixels2.count {
            
            pixels2 = traverse().MakePointBlack(width: width, height: height, x: x, y: y, pixels: pixels2)
            x = x+1
            y = x
            
        }
       
        
        /*
        var blah = false
        for index in pixels.indices {
            if !(index == 0) {
                if 1 == index/index {
                    blah = true
                }
            }
            if blah {
                pixels[index].a = 255
                pixels[index].r = 0
                pixels[index].g = 0
                pixels[index].b = 0
                blah = false
            } else {
                pixels[index].a = 255
                pixels[index].r = 255
                pixels[index].g = 255
                pixels[index].b = 255
            }
        } */
        
        image = UIImage(pixels: pixels2, width: width, height: height)!
        finished = true
    }
    
    //https://www.codingame.com/playgrounds/2358/how-to-plot-the-mandelbrot-set/mandelbrot-set
    @State var maxIter = 80
    //https://stackoverflow.com/questions/24005164/complex-numbers-in-swift
    func mandelbrot(c: Complex<Double>) -> Int {
        var z: Complex<Double> = Complex<Double>(0.0)
        var n = 0
        while abs(Double(z.real)) <= 2 && n < maxIter {
            z = z*z + c
            //print(z.real)
            n += 1
            
        }
        return n
        
    }
    
    
    var body: some View {
        
        
        VStack {
            if finished {
                Image(uiImage: image).resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 700, alignment: .center)
                    .border(.blue).rotationEffect(.degrees(-90))
            } else {
                Text("Loading..")
            }
        }.onAppear {
            
            //oldOnappear()
            let height = 600
            let width = 600
            let RE_START = -2.0
            let RE_END = 1.0
            let IM_START = -1.0
            let IM_END = 1.0
          
            var pixels: [PixelData] = .init(repeating: .init(a: 0, r: 0, g: 0, b: 0), count: width * height)
            
            for index in pixels.indices {
             
                    pixels[index].a = 255
                    pixels[index].r = 255
                    pixels[index].g = 255
                    pixels[index].b = 255
                
            }
            
            for x in (0...width) {
                for y in (0...height) {
                    var real = RE_START + (Double(x) / Double(width)) * (RE_END - RE_START)
                    var imag = IM_START + (Double(y) / Double(height)) * (IM_END - IM_START)
                    
                    var c = Complex(real, imag)
                    //print(c)
                    var m = mandelbrot(c: c)
                    var color = 255 - Int(m * 255 / maxIter)
                    pixels = traverse().drawPoint(width: width, height: height, x: x, y: y, pixels: pixels, color: UInt8(color))
                    
                }
            }
            image = UIImage(pixels: pixels, width: width, height: height)!
            finished = true
            
            
            
            
        }
        .padding()
    }
}



//https://stackoverflow.com/questions/30958427/pixel-array-to-uiimage-in-swift
extension UIImage {
    convenience init?(pixels: [PixelData], width: Int, height: Int) {
        guard width > 0 && height > 0, pixels.count == width * height else { return nil }
        var data = pixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<PixelData>.size) as CFData)
            else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent)
        else { return nil }
        self.init(cgImage: cgim)
    }
}
//https://stackoverflow.com/questions/44033762/testing-if-a-decimal-is-a-whole-number-in-swift#44035036
extension Decimal {
    var isWholeNumber: Bool {
        return self.isZero || (self.isNormal && self.exponent >= 0)
    }
}
