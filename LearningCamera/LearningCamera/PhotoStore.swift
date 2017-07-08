//
//  PhotoStore.swift
//  LearningCamera
//
//  Created by Colin3dmax on 2017/7/6.
//  Copyright © 2017年 51Parcel. All rights reserved.
//

import UIKit

class PhotoStore:NSObject {
    var photos = [Photo]()
    var cellForPhoto:(Photo,IndexPath)->UICollectionViewCell
    
    init(cellForPhoto: @escaping (Photo,IndexPath)->UICollectionViewCell ){
        self.cellForPhoto = cellForPhoto
        super.init()
    }
    
    
    func loadPhotos() throws {
        self.photos.removeAll(keepingCapacity: true)
        let fileManager = FileManager.default
        let saveDirectory = try self.getSaveDirectory()
        let enumerator = fileManager.enumerator(atPath: saveDirectory.relativePath)
        while let file = enumerator?.nextObject() as? String {
            let fileType = enumerator!.fileAttributes![FileAttributeKey.type] as! String
            if fileType == FileAttributeType.typeRegular.rawValue {
                let fullPath = saveDirectory.appendingPathComponent(file)
                if let photo = Photo(filePath: fullPath){
                    self.photos.append(photo)
                }
            }
        }
    }
    
    
}


extension PhotoStore :UICollectionViewDataSource {
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = self.photos[indexPath.item]
        return self.cellForPhoto(photo,indexPath)
    }

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
        
    func saveNewPhotoWithImage(image:UIImage,labeled label:String)throws ->IndexPath{
        let photo = Photo(image: image, label: label)
        //保存照片到本地
        try photo.saveToDirectory(directory: self.getSaveDirectory())
        self.photos.append(photo)
        return IndexPath(item: self.photos.count - 1, section: 0)
    }
    
    
}

private extension PhotoStore {
    func getSaveDirectory() throws -> URL {
        let fileManager = FileManager.default
        return try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

