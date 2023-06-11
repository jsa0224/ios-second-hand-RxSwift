//
//  EndPoint.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/23.
//

import Foundation

final class Endpoint {
    private let baseUrl: String
    private let path: String
    private let method: HTTPMethod
    private let queries: [String: Any]

    init(
        baseUrl: String,
        path: String,
        method: HTTPMethod,
        queries: [String : Any] = [:]
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.queries = queries
    }

    func generateRequest() throws -> URLRequest {
        let url = try generateUrl()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.description

        return urlRequest
    }

    func generateImageRequest() throws -> URLRequest {
        let url = try generateBaseUrl()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.description

        return urlRequest
    }

    func generateUrl() throws -> URL {
        let urlString = baseUrl + path

        var component = URLComponents(string: urlString)
        component?.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        guard let url = component?.url else {
            throw NetworkError.invalidUrl
        }

        return url
    }

    func generateBaseUrl() throws -> URL {
        let component = URLComponents(string: baseUrl)

        guard let url = component?.url else {
            throw NetworkError.invalidUrl
        }

        return url
    }
}
