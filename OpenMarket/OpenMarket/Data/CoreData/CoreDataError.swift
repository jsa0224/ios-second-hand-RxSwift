//
//  CoreDataError.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import Foundation

enum CoreDataError: LocalizedError {
    case readFail
    case saveFail

    var description: String {
        switch self {
        case .readFail:
            return ErrorMessage.readFail
        case .saveFail:
            return ErrorMessage.saveFail
        }
    }

    private enum ErrorMessage {
        static let readFail = "저장소를 불러올 수 없습니다."
        static let saveFail = "저장소에 저장할 수 없습니다."
    }
}
