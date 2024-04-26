//
//  ImageUseCase.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/27.
//

import UIKit
import RxSwift

final class ImageUseCase: ImageUseCaseType {
    private let imageRepository: NetworkRepository

    init(imageRepository: NetworkRepository) {
        self.imageRepository = imageRepository
    }

    func fetchItemImage(_ url: String) -> Observable<UIImage> {
        return imageRepository.fetchImage(url: url)
    }
}
