//
//  LocalPhotoCollectionViewController.swift
//  SocialPhotoApp
//
//  Created by sergio on 23/04/2019.
//  Copyright © 2019 PacktPublishing. All rights reserved.
//

import UIKit

class LocalPhotoCollectionViewController: PhotoCollectionViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func addFromCamera(_ sender: Any) {
        presentPicker(.camera, delegate: self)
    }
    
    @IBAction func addFromRoll(_ sender: Any) {
        presentPicker(.photoLibrary, delegate: self)
    }
    
    //////////////////////////////////////////////////////////////
    
    private func presentPicker(_ type : UIImagePickerController.SourceType,
                               delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        
        imagePicker.delegate = delegate
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[.imageURL] as? URL)
        viewModel.addPhoto(image: image!)
        imagePicker.dismiss(animated: true, completion: nil)
        
        self.collectionView.reloadData()
    }
    
    //////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {

        // we need viewModel to be in place before calling super.viewDidLoad
        viewModel = PhotoCollectionViewModel(query: PhotoCollectionViewModel.userQuery())

        super.viewDidLoad()
        
        checkPhotoLibraryPermission()
    }
    
    //////////////////////////////////////////////////////////////
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            viewModel.removePhoto(photo: cell.photoInfo)
        } else {
            print("couldn't find index path")
        }
        gesture.state = .ended
    }
}
