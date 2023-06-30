//
//  ItemRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/24.
//

import UIKit
import RxSwift

final class ItemRepository: NetworkRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchItemList(pageNo: Int, itemPerPage: Int) -> Observable<[Item]> {
        let endpoint = EndpointStorage
            .searchProduct(pageNo: pageNo, itemPerPage: itemPerPage)
            .asEndpoint

        return networkManager.executeProductList(endpoint: endpoint)
            .decode(type: ProductList.self, decoder: JSONDecoder())
            .map { response in
                let product = response.pages 

                return product.compactMap { $0.toDomain() }
            }
    }

    func fetchItemList(searchValue: String) -> Observable<[Item]> {
        let endpoint = EndpointStorage
            .searchProductByName(searchValue: searchValue)
            .asEndpoint

        return networkManager.executeProductList(endpoint: endpoint)
            .decode(type: ProductList.self, decoder: JSONDecoder())
            .map { response in
                let product = response.pages

                return product.compactMap { $0.toDomain() }
            }
    }

    func fetchImage(url: String) -> Observable<UIImage> {
        let cachedKey = NSString(string: url)

        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return Observable.just(cachedImage)
        }

        let endpoint = EndpointStorage
            .searchProductImage(url)
            .asEndpoint

        return networkManager
                .executeProductImage(endpoint: endpoint)
                .map {
                    let image = UIImage(data: $0) ?? UIImage()
                    ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                    return image
                }
    }
}
