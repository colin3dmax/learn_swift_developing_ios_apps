//
//  ViewController.swift
//  LearningCamera
//
//  Created by Colin3dmax on 2017/7/6.
//  Copyright © 2017年 51Parcel. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos = [Photo]()
    var photoStore:PhotoStore!
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try self.photoStore.loadPhotos()
            self.collectionView.reloadData()
        }
        catch let error {
            self.displayError(error: error, widthTitle: "Error Loading Photos")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoStore = PhotoStore(cellForPhoto: self.createCellForPhoto)
        self.collectionView.dataSource = self.photoStore
    }
    
    
    func createCellForPhoto(photo:Photo,indexPath:IndexPath)->UICollectionViewCell{
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = photo.image
        cell.label.text = photo.label
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapTakePhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapEditButton(_ sender: Any) {
    }
    
}

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = self.photos[indexPath.item]
        cell.imageView.image = photo.image
        cell.label.text = photo.label
        
        return cell
    }
}

extension ViewController:UINavigationControllerDelegate {
    
}

extension ViewController:UIImagePickerControllerDelegate{
    
    func displayErrorWithTitle(title:String?,message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError(error:Error,widthTitle:String){
        switch error {
//        case let error as Error:
//            self.displayErrorWithTitle(title: title, message: error.localizedDescription)
        case let error as Photo.MyError:
            self.displayErrorWithTitle(title: title, message: error.rawValue)
        default:
            self.displayErrorWithTitle(title: title, message: "Unknown Error")
        }
    }
    
    func createSaveActionWithTextField(textField:UITextField,andImage image:UIImage) -> UIAlertAction {
        return  UIAlertAction(title: "Save", style: .default, handler: { action in
            let label = textField.text ?? ""
            do {
                let indexPath = try self.photoStore.saveNewPhotoWithImage(image: image, labeled: label)
                self.collectionView.insertItems(at: [indexPath as IndexPath])
            }
            catch let error {
                self.displayError(error:error,widthTitle:"Error Saving Photo")
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        self.dismiss(animated: true) { 
            let alertController = UIAlertController(title: "Photo Label", message: "How would you like to label your photo?", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { textField in
                let saveAction = self.createSaveActionWithTextField(textField: textField, andImage: image)
                alertController.addAction(saveAction)
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
}














































