//
//  ItemNetworkManager.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import Foundation
import RxSwift

final class ItemNetworkManager: NetworkManager {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func executeProductList(endpoint: Endpoint) -> Observable<Data> {
        return Single<Data>.create { [weak self] single in
            guard let urlRequest = try? endpoint.generateRequest() else {
                return Disposables.create()
            }

            let task = self?.urlSession.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    single(.failure(NetworkError.errorIsOccurred(error.debugDescription)))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }

                guard let data = data else {
                    single(.failure(NetworkError.invalidData))
                    return
                }

                single(.success(data))
            }
            task?.resume()

            return Disposables.create {
                task?.suspend()
                task?.cancel()
            }
        }.asObservable()
    }

    func executeProductImage(endpoint: Endpoint) -> Observable<Data> {
        return Single<Data>.create { [weak self] single in
            guard let urlRequest = try? endpoint.generateImageRequest() else {
                return Disposables.create()
            }

            let task = self?.urlSession.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    single(.failure(NetworkError.errorIsOccurred(error.debugDescription)))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }

                guard let data = data else {
                    single(.failure(NetworkError.invalidData))
                    return
                }

                single(.success(data))
            }
            task?.resume()

            return Disposables.create {
                task?.suspend()
                task?.cancel()
            }
        }.asObservable()
    }
}
