//
//  ImageUseCase.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/27.
//

import Foundation

final class ImageUseCase: ImageUseCaseType {
    private let imageRepository: NetworkRepository

    init(imageRepository: NetworkRepository) {
        self.imageRepository = imageRepository
    }

    func fetchItemImage(_ url: String) {
        imageRepository.fetchImage(url: url)
    }
}
