//
//  PhotoViewController.swift
//  Photo2
//
//  Created by sergio on 31/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView : UITextField!
    @IBOutlet weak var descriptionView : UITextView!
    @IBOutlet weak var tagView : UITextField!

    var shareButton : UIBarButtonItem?
    var shareText : String {
        return isShared ? "Unshare" : "Share"
    }
    
    var photoInfo = PhotoInfo()
    var callback : ((_ : PhotoInfo) -> Void)?
    
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate var auth = Auth.auth()

    fileprivate var isShared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionView.layer.borderWidth = 1.0
        descriptionView.layer.borderColor = UIColor(white: 0.2, alpha: 0.15).cgColor

        imageView.setImage(storageChild: photoInfo.filename)

        titleView.text = photoInfo.title
        descriptionView.text = photoInfo.description
        tagView.text = photoInfo.tags.joined(separator: ",")
        
        isShared = (photoInfo.status == .Public)
        
        shareButton = UIBarButtonItem(title: shareText,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareCurrentPhoto(sender:)))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.authStateDidChangeHandle =
            auth.addStateDidChangeListener(self.updateUI(auth:user:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let handle = self.authStateDidChangeHandle {
            auth.removeStateDidChangeListener(handle)
        }

        if self.isMovingFromParent && photoInfo.userId == auth.currentUser?.uid {
            photoInfo = PhotoInfo(uid: photoInfo.uid,
                                  userId: photoInfo.userId,
                                  filename: photoInfo.filename,
                                  title: titleView.text ?? "Image title goes here",
                                  description: descriptionView.text ?? "",
                                  status: PhotoInfo.makeStatus(isShared),
                                  tags: PhotoInfo.makeTags(tagView.text))
            if let callback = callback {
                callback(photoInfo)
            }
        }
    }

    func updateUI(auth: Auth, user: User?) {
        if photoInfo.userId == auth.currentUser?.uid {
            shareButton?.isEnabled = true
            titleView.isUserInteractionEnabled = true
            tagView.isUserInteractionEnabled = true
            descriptionView.isUserInteractionEnabled = true
        } else {
            shareButton?.isEnabled = false
            titleView.isUserInteractionEnabled = false
            tagView.isUserInteractionEnabled = false
            descriptionView.isUserInteractionEnabled = false
        }
    }

    @objc private func shareCurrentPhoto(sender: Any) {
        isShared = !isShared
        shareButton?.title = shareText
    }
    
}
