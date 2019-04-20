//
//  PhotoViewController.swift
//  Photo2
//
//  Created by sergio on 31/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView : UITextField!
    @IBOutlet weak var descriptionView : UITextView!
    @IBOutlet weak var tagView : UITextField!

    var photoInfo = PhotoInfo()
    var callback : ((_ : PhotoInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionView.layer.borderWidth = 1.0
        descriptionView.layer.borderColor = UIColor(white: 0.2, alpha: 0.15).cgColor

        let storage = Storage.storage()
        imageView.sd_setImage(with: storage.reference().child(photoInfo.filename),
                              placeholderImage: UIImage(named: "Downloading"))

        titleView.text = photoInfo.title
        descriptionView.text = photoInfo.description
        tagView.text = photoInfo.tags.joined(separator: ",")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            photoInfo = PhotoInfo(uid: photoInfo.uid,
                                  filename: photoInfo.filename,
                                  title: titleView.text ?? "Image title goes here",
                                  description: descriptionView.text ?? "",
                                  tags: PhotoInfo.makeTags(tagView.text))
            if let callback = callback {
                callback(photoInfo)
            }
        }
    }

}
