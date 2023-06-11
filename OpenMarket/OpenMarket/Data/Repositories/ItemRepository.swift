//
//  ItemRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/24.
//

import Foundation
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

    func fetchImage(url: String) -> Observable<Data> {
        let endpoint = EndpointStorage
            .searchProductImage(url)
            .asEndpoint

        return networkManager.executeProductImage(endpoint: endpoint)
    }
}
