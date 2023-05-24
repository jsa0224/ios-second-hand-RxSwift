//
//  EndpointStorage.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/23.
//

import Foundation

enum EndpointStorage {

    private enum Constant {
        static let baseUrl = "https://openmarket.yagom-academy.kr"
        static let searchPath = "/api/products?"
    }

    case searchProduct(pageNo: Int, itemPerPage: Int)
    case searchProductImage(String)
}

extension EndpointStorage {
    var asEndpoint: Endpoint {
        switch self {
        case .searchProduct(let pageNo, let itemPerPage):
            return Endpoint(
                baseUrl: Constant.baseUrl,
                path: Constant.searchPath,
                method: .get,
                queries: [
                    "page_no" : pageNo,
                    "items_per_page" : itemPerPage
                ]
            )
        case .searchProductImage(let url):
            return Endpoint(
                baseUrl: url,
                path: "",
                method: .get,
                queries: [:]
            )
        }
    }
}
