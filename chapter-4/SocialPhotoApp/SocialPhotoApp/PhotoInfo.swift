//
//  PhotoInfo.swift
//  Photo2
//
//  Created by sergio on 31/03/2019.
//  Copyright © 2019 Sergio De Simone. All rights reserved.
//

import Foundation
import SQLite3
import Firebase

enum PhotoStatus {
    case Public
    case Private
}

struct PhotoInfo {
    let uid: String
    let userId: String
    let filename: String
    let title: String
    let description: String
    let status : PhotoStatus
    let tags: [String]
    
    static func makeStatus(_ s: Any?) -> PhotoStatus {
        return (s as? String == "public" || s as? Bool == true) ? .Public : .Private
    }

    static func makeTags(_ s: Any?) -> [String] {
        return (s as? String)?.components(separatedBy: CharacterSet(charactersIn: ",")) ?? []
    }
    

    init(uid: String,
         userId: String,
         filename: String,
         title: String,
         description: String,
         status: PhotoStatus,
         tags: [String]) {
        
        self.uid = uid
        self.userId = userId
        self.filename = filename
        self.title = title
        self.description = description
        self.status = status
        self.tags = tags
    }

    init(uid: String = "", data: [String : Any] = [:]) {
        
        self.init(uid: uid,
                  userId: data["userId"] as? String ?? "NoUser",
                  filename: data["filename"] as? String ?? "",
                  title: data["title"] as? String ?? "",
                  description: data["description"] as? String ?? "",
                  status: (data["status"] as? String == "public") ? .Public : .Private,
                  tags: data["tags"] as? [String] ?? PhotoInfo.makeTags(data["tags"]))
    }

}
