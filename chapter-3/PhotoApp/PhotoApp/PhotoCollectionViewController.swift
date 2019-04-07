//
//  PhotoCollectionViewController.swift
//  Photo2
//
//  Created by sergio on 30/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotoCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var imagePicker : UIImagePickerController!
    let viewModel : PhotoCollectionViewModel = PhotoCollectionViewModel()

    @IBAction func addFromCamera(_ sender: Any) {
        presentPicker(.camera, delegate: self)
    }
    
    @IBAction func addFromRoll(_ sender: Any) {
        presentPicker(.photoLibrary, delegate: self)
    }
    
//////////////////////////////////////////////////////////////

    private func presentPicker(_ type : UIImagePickerController.SourceType,
                               delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        imagePicker = UIImagePickerController()
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
        super.viewDidLoad()

        checkPhotoLibraryPermission()
        
    }
    
//////////////////////////////////////////////////////////////

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.photoCount()
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // reuse cell for performance
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        
        // retrieve the photo at the requested index
        cell.photoInfo = viewModel.photo(index: indexPath[1] + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemsPerRow = 3
        let paddingSpace = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    
//////////////////////////////////////////////////////////////

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: textField.bounds.size.width - 32,
                                         y: 0, width: 32, height: textField.bounds.size.height)
        activityIndicator.startAnimating()

        viewModel.currentTag = textField.text
        self.collectionView.reloadData()

        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
