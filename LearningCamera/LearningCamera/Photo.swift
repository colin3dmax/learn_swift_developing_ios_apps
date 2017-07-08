//
//  Photo.swift
//  LearningCamera
//
//  Created by Colin3dmax on 2017/7/6.
//  Copyright © 2017年 51Parcel. All rights reserved.
//
import UIKit

struct Photo {
    let image:UIImage
    let label:String
    
    enum MyError:String,Error {
        case CouldntGetImageData = "Couldn't get data from image"
        case CouldntWriteImageData = "Couldn't write image data"
    }
    
    init(image:UIImage,label:String){
        self.image = image
        self.label = label
    }
    
    init?(filePath:URL){
        if let image = UIImage(contentsOfFile: filePath.relativePath) {
            let label = filePath.deletingPathExtension().lastPathComponent
            self.init(image: image, label: label)
        }
        else{
            return nil
        }
    }
    
    func saveToDirectory(directory:URL) throws  {
        let timeStamp = "\(Date().timeIntervalSince1970)"
        let fullDirectory = directory.appendingPathComponent(timeStamp)
        try FileManager.default.createDirectory(at: fullDirectory, withIntermediateDirectories: true, attributes: nil)
        let fileName = "\(self.label).jpg"
        let filePath = fullDirectory.appendingPathComponent(fileName)
        if let data = UIImageJPEGRepresentation(self.image, 1){
            do{
                try data.write(to: filePath, options: Data.WritingOptions.atomic)
            }catch {
                throw MyError.CouldntWriteImageData
            }
        }else{
            throw MyError.CouldntGetImageData
        }
    }
    
}

