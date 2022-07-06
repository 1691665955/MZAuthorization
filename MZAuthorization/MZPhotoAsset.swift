//
//  MZPhotoAsset.swift
//  MZAuthorization
//
//  Created by 曾龙 on 2022/7/5.
//

import UIKit
import Photos

struct MZPhotoAsset {
    static func saveImage(image: UIImage, collectionName: String?, completion: ((Bool) -> Void)?) {
        if let title = collectionName {
            getPhotoCollection(title: title) { collection in
                let library = PHPhotoLibrary.shared()
                library.performChanges {
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let placeholder = request.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: collection)
                    albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
                } completionHandler: { success, error in
                    DispatchQueue.main.async {
                        if error == nil {
                            if completion != nil {
                                completion!(true)
                            }
                        } else {
                            if completion != nil {
                                completion!(false)
                            }
                        }
                    }
                }
            }
        } else {
            let library = PHPhotoLibrary.shared()
            library.performChanges {
                let options = PHAssetResourceCreationOptions()
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: image.pngData()!, options: options)
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if error == nil {
                        if completion != nil {
                            completion!(true)
                        }
                    } else {
                        if completion != nil {
                            completion!(false)
                        }
                    }
                }
            }
        }
    }
    
    private static func getPhotoCollection(title: String, completion: @escaping (PHAssetCollection)->Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@",title)
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let collection = result.firstObject {
            completion(collection)
        } else {
            var localIdentifier = ""
            PHPhotoLibrary.shared().performChanges({
                let collectionRequest: PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                localIdentifier = collectionRequest.placeholderForCreatedAssetCollection.localIdentifier
            }) { success, error in
                if (error == nil) {
                    let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [localIdentifier], options: nil)
                    completion(assetCollection.firstObject!)
                }
            }
        }
    }
}
