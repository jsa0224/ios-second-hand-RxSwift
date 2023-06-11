//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/24.
//

import Foundation
import RxSwift

protocol NetworkManager {
    func executeProductList(endpoint: Endpoint) -> Observable<Data>
    func executeProductImage(endpoint: Endpoint) -> Observable<Data>
}
