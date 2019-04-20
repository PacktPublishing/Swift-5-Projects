//
//  PhotoCollectionViewModel.swift
//  PhotoApp
//
//  Created by sergio on 06/04/2019.
//  Copyright © 2019 PacktPublishing. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class PhotoCollectionViewModel {
    
    let db : Firestore
    let photos : CollectionReference
    let storage : Storage

    var currentQuery : Query
    var currentTag : String? {
        didSet(value) {
            if let currentTag = currentTag, currentTag != "" {
                self.currentTag = currentTag
                currentQuery = photos.whereField("tags", arrayContains: currentTag)
            } else {
                currentTag = nil
                currentQuery = photos
            }
        }
    }

    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        photos = db.collection("photos")
        storage = Storage.storage()
        currentQuery = photos
    }
    
    func addPhoto(image: URL) {
        
        let storageRef = storage.reference().child(image.lastPathComponent)
        let uploadTask = storageRef.putFile(from: image, metadata: nil) { metadata, error in
            if let error = error {
                print("Error while adding photo: \(error)")
                return
            }
            self.db.collection("photos").addDocument(data: [
                "filename": image.lastPathComponent,
                "title": "Photo title",
                "description": "",
                "tags": []
                ])
        }
        uploadTask.resume()
    }

    func updatePhoto(photo: PhotoInfo) {
        self.db.collection("photos").document(photo.uid).updateData([
            "title": photo.title,
            "description": photo.description,
            "tags": photo.tags
            ])
    }
}