//
//  ItemListRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/24.
//

import Foundation
import RxSwift

final class ItemListRepository: NetworkRepository {
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
                guard let product = response.pages else { throw NetworkError.decodedError }

                return product.compactMap { $0.toDomain() }
            }
    }

    func fetchItemImage(url: String) -> Observable<Data> {
        let endpoint = EndpointStorage
            .searchProductImage(url)
            .asEndpoint

        return networkManager.executeProductImage(endpoint: endpoint)
            .decode(type: Data.self, decoder: JSONDecoder())
    }
}
