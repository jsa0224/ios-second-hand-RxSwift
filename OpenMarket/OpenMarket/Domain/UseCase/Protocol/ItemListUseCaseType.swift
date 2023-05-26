//
//  ItemListUseCaseType.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/26.
//

import Foundation

protocol ItemListUseCaseType {
    func fetchItemList(_ pageNo: Int, _ itemPerPage: Int)
}
