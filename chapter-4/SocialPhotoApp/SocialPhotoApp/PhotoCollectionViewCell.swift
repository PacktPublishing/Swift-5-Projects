//
//  PhotoCollectionViewCell.swift
//  Photo2
//
//  Created by sergio on 31/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import UIKit
import Firebase

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    var photoInfo = PhotoInfo() {
        willSet(newInfo) {
            let storage = Storage.storage()
            imageView.sd_setImage(with: storage.reference().child(newInfo.filename),
                                  placeholderImage: UIImage(named: "Downloading"))
        }
    }
}
