//
//  Utils.swift
//  Photos
//
//  Created by sergio on 03/04/2019.
//  Copyright © 2019 PacktPublishing. All rights reserved.
//

import Foundation


func URLIntoDocuments(_ component: String) -> URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(component)
}
