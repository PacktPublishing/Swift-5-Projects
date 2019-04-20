//
//  Utils.swift
//  Photos
//
//  Created by sergio on 03/04/2019.
//  Copyright © 2019 PacktPublishing. All rights reserved.
//

import Foundation
import Photos

func URLIntoDocuments(_ component: String) -> URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(component)
}

func checkPhotoLibraryPermission() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized:
        print("Access already granted")
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus == PHAuthorizationStatus.authorized {
                print("Access granted")
            }
        })
    case .restricted:
        print("Access unavailable to user.")
    case .denied:
        // same same
        print("Access denied.")
    @unknown default:
        print("Unrecoverable error: unkwnown PHAuthorizationStatus case")
    }
}

func copyImage(src: URL) -> String? {
    
    let fileURL = URLIntoDocuments(src.lastPathComponent)
    let image = UIImage(named: src.path)!
    if let data = image.jpegData(compressionQuality:  1.0),
        !FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try data.write(to: fileURL)
            print("File \(fileURL) copied")
            return src.lastPathComponent
        } catch {
            print("Error copying file:", error)
        }
    }
    return nil
}