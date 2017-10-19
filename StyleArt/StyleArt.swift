//
//  StyleArt.swift
//  StyleArts
//
//  Created by Levin  on 17/10/17.
//  Copyright © 2017 Levin . All rights reserved.
//

import Foundation
import CoreML
import UIKit

///ArtStyle enum defines the number of styles present in StyleArt
enum ArtStyle:Int {
    
    case Mosaic = 0
    case scream = 1
    case Muse   = 2
    case Udanie = 3
    case Candy  = 4
    case Feathers = 5
}

///Style Art class process images using COREML on a set of pre trained machine learning models and convert them to Art style.
class StyleArt{
    
    //MARK:- Properties
    var models:[MLModel]=[]
    //CoremL model instance
    var museModel: FNS_La_Muse_1!
    var candy:FNS_Candy_1!
    var Feathers:FNS_Feathers_1!
    var udanieModel:FNS_Udnie_1!
    var mosaic:FNS_Mosaic_1!
    var screamModel:FNS_The_Scream_1!
    //Height constant for image processing
    let imageSize = 720
    
    //MARK:- Shared singleton
    ///Shared Instance of StyleArt class
    static let shared = StyleArt()
    
   
   //MARK:- Private Initializer
   private init() {
        //load all style models from bundle.
        do {
            let pathMuse = Bundle.main.path(forResource: "FNS-La-Muse", ofType: "mlmodelc")
            let pathCandy = Bundle.main.path(forResource: "FNS-Candy", ofType: "mlmodelc")
            let pathFeathers = Bundle.main.path(forResource: "FNS-Feathers", ofType: "mlmodelc")
            let pathUdanie = Bundle.main.path(forResource: "FNS-Udnie", ofType: "mlmodelc")
            let pathMosaic = Bundle.main.path(forResource: "FNS-Mosaic", ofType: "mlmodelc")
            let pathScream = Bundle.main.path(forResource: "FNS-The-Scream", ofType: "mlmodelc")
            
            museModel = try FNS_La_Muse_1(contentsOf:URL(fileURLWithPath: pathMuse!) )
            candy = try FNS_Candy_1(contentsOf:URL(fileURLWithPath: pathCandy!) )
            Feathers = try FNS_Feathers_1(contentsOf:URL(fileURLWithPath: pathFeathers!) )
            udanieModel = try FNS_Udnie_1(contentsOf:URL(fileURLWithPath: pathUdanie!) )
            mosaic = try FNS_Mosaic_1(contentsOf:URL(fileURLWithPath: pathMosaic!) )
            screamModel = try FNS_The_Scream_1(contentsOf:URL(fileURLWithPath: pathScream!) )
            
            models.append(mosaic.model)
            models.append(screamModel.model)
            models.append(museModel.model)
            models.append(udanieModel.model)
            models.append(candy.model)
            models.append(Feathers.model)
            
        } catch let error {
            print(error)
        }
    }
    
    //MARK:- Image Processing
    ///Process method performs the style art transfer of the given image based on the style chosen and returns the result in closure.
    /// - parameter image:          The Image on which styles are applied.
    /// - parameter ArtStyle:       The styles present in ArtStyle enum.
    /// - parameter compeletion:    The closure which return the final processed image,if the   operation is failed it will return nil.
    func process(image:UIImage,style:ArtStyle,compeletion:(_ result:UIImage?)->()){

        let model = models[style.rawValue]
        
        if let pixelBufferd = image.pixelBuffer(width: 720, height: 720) {
            let input = StyleArtInput(input:pixelBufferd)
            let outFeatures = try! model.prediction(from: input)
            let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
            if let result = UIImage(pixelBuffer: output) {
                print("Done");
                compeletion(result)
            }else{
                print("Failed");
                compeletion(nil)
            }
 
        }
    }
    //MARK:- Private Helper Functions
    private func stylizeImage(cgImage: CGImage, model: MLModel) -> CGImage {
        let input = StyleArtInput(input: pixelBuffer(cgImage: cgImage, width: imageSize, height: imageSize))
        let outFeatures = try! model.prediction(from: input)
        let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
        CVPixelBufferLockBaseAddress(output, .readOnly)
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: CVPixelBufferGetBytesPerRow(output),
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
    }
    ///Method which converts given CGImage to CVPixelBuffer.
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer!
    }
    
    
}
