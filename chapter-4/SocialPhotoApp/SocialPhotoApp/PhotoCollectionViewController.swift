//
//  PhotoCollectionViewController.swift
//  Photo2
//
//  Created by sergio on 30/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import UIKit
import FirebaseUI

private let reuseIdentifier = "PhotoCell"

class PhotoCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate {

    let imagePicker = UIImagePickerController()
    let viewModel : PhotoCollectionViewModel = PhotoCollectionViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var dataSource : FUIFirestoreCollectionViewDataSource!

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
    
    private func bindToCurrentQuery(activityIndicator: UIActivityIndicatorView?) {
        
        let q = viewModel.currentQuery
        self.dataSource = collectionView.bind(toFirestoreQuery: q) { view, indexPath, snap in

            if let activityIndicator = activityIndicator {
                activityIndicator.stopAnimating()
            }
            let cell = view.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                for: indexPath) as! PhotoCollectionViewCell
            
            cell.photoInfo = PhotoInfo(uid: snap.documentID,
                                       data: snap.data()!)
            return cell
        }
    }
    
//////////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPhotoLibraryPermission()
        bindToCurrentQuery(activityIndicator: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(self.handleLongPress))
        longPress.delegate = self;
        longPress.delaysTouchesBegan = true;
        longPress.minimumPressDuration = 1;
//        longPress.numberOfTouchesRequired = 2;
        self.collectionView.addGestureRecognizer(longPress)
    }
    
//////////////////////////////////////////////////////////////

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoCell = sender as? PhotoCollectionViewCell,
            let vc = segue.destination as? PhotoViewController {
                vc.photoInfo = photoCell.photoInfo
            vc.callback = { info in
                self.viewModel.updatePhoto(photo: info)
                self.collectionView.reloadData()
            }
        }
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
        bindToCurrentQuery(activityIndicator: activityIndicator)

        return true
    }

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
