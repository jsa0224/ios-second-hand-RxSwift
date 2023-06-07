//
//  ImageUseCaseType.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/27.
//

import Foundation
import RxSwift

protocol ImageUseCaseType {
    func fetchItemImage(_ url: String) -> Observable<Data>
}
