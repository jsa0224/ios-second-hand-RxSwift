//
//  NetworkRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/24.
//

import Foundation
import RxSwift

protocol NetworkRepository {
    func fetchItemList(pageNo: Int, itemPerPage: Int) -> Observable<[Item]>
    func fetchImage(url: String) -> Observable<Data>
}
