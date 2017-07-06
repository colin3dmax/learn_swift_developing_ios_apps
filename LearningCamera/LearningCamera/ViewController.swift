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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

extension ViewController:UINavigationControllerDelegate {}

extension ViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        self.dismiss(animated: true) { 
            let alertController = UIAlertController(title: "Photo Label", message: "How would you like to label your photo?", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { textField in
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
                    let label = textField.text ?? ""
                    let photo = Photo(image: image, label: label)
                    self.photos.append(photo)
                    
                    let indexPath = NSIndexPath(item: self.photos.count-1, section: 0)
                    self.collectionView.insertItems(at: [indexPath as IndexPath])
                })
                alertController.addAction(saveAction)
            })
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
}
