//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/13.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
