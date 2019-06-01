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

struct PhotoInfo {
    let uid: String
    let filename: String
    let title: String
    let description: String
    let tags: [String]
    
    static func makeTags(_ s: Any?) -> [String] {
        return (s as? String)?.components(separatedBy: CharacterSet(charactersIn: ",")) ?? []
    }

    init(uid: String, filename: String, title: String, description: String, tags: [String]) {
        
        self.uid = uid
        self.filename = filename
        self.title = title
        self.description = description
        self.tags = tags
    }

    init(uid: String = "", data: [String : Any] = [:]) {
        
        self.init(uid: uid,
                  filename: data["filename"] as? String ?? "",
                  title: data["title"] as? String ?? "",
                  description: data["description"] as? String ?? "",
                  tags: data["tags"] as? [String] ?? PhotoInfo.makeTags(data["tags"]))
    }

}
