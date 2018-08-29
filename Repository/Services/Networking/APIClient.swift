//
//  APIClient.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
protocol APIClient {
    var baseURL: URL { get }
}

extension APIClient {
    func load<T: Decodable>(apiRequest: APIRequest) -> Observable<T> {
        return load(apiRequest: apiRequest, withBaseURL: baseURL)
    }

    func load<T: Decodable>(apiRequest: APIRequest, overrideBaseURLWith baseURL: URL) -> Observable<T> {
        return load(apiRequest: apiRequest, withBaseURL: baseURL)
    }

    private func load<T: Decodable>(apiRequest: APIRequest, withBaseURL baseURL: URL) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        observer.onError(error)
                        observer.onCompleted()
                    }
                    return
                }

                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    DispatchQueue.main.async {
                        observer.onNext(model)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        observer.onError(error)
                    }
                }
                DispatchQueue.main.async {
                    observer.onCompleted()
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
