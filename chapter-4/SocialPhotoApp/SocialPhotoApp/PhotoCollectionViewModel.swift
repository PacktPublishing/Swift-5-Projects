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

    static func userQuery() -> (CollectionReference) -> Query {
        return { (_ c : CollectionReference) -> Query in
            return c.whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "NoUser")
        }
    }
    
    static func publicQuery() -> (CollectionReference) -> Query {
        return { (_ c : CollectionReference) -> Query in
            return c.whereField("status", isEqualTo: "public")
        }
    }
    
    var baseQuery : Query
    var currentQuery : Query
    var currentTag : String? {
        didSet(value) {
            if let currentTag = currentTag, currentTag != "" {
                self.currentTag = currentTag
                currentQuery = baseQuery.whereField("tags", arrayContains: currentTag)
            } else {
                currentTag = nil
                currentQuery = baseQuery
            }
        }
    }

    init(query: (CollectionReference) -> Query) {
        db = Firestore.firestore()
        photos = db.collection("photos")
        storage = Storage.storage()
        baseQuery = query(photos)
        currentQuery = baseQuery
    }
    
    func addPhoto(image: URL) {
        
        // copy image so we can use it as a placeholder
        let _ = copyImage(src: image)

        let storageRef = storage.reference().child(image.lastPathComponent)
        let uploadTask = storageRef.putFile(from: image, metadata: nil) { metadata, error in
            if let error = error {
                print("Error while adding photo: \(error)")
                return
            }
            self.db.collection("photos").addDocument(data: [
                "userId": Auth.auth().currentUser?.uid ?? "NoUser",
                "filename": image.lastPathComponent,
                "title": "Photo title",
                "description": "",
                "status": "private",
                "tags": []
                ])
        }
        uploadTask.resume()
    }

    func updatePhoto(photo: PhotoInfo) {
        self.db.collection("photos").document(photo.uid).updateData([
            "title": photo.title,
            "description": photo.description,
            "status": (photo.status == .Public) ? "public" : "private",
            "tags": photo.tags
            ])
    }
    
    func removePhoto(photo: PhotoInfo) {
        self.db.collection("photos").document(photo.uid).delete()
    }

}
