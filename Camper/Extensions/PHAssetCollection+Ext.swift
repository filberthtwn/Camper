//
//  PHAssetCollection+Ext.swift
//  Camper
//
//  Created by Filbert Hartawan on 18/12/21.
//

import Foundation
import Photos

extension PHAssetCollection{
    var count: Int {
        let fetchOptions = PHFetchOptions()
        let imageResult = PHAsset.fetchAssets(in: self, options: fetchOptions)
        
        return imageResult.count
    }
}
