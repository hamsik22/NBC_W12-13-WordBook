//
//  NetworkManager.swift
//  SwiftRun
//
//  Created by 김석준 on 1/8/25.
//

import Foundation
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // Generic fetch method
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                    single(.failure(statusCodeError))
                    return
                }

                guard let data = data else {
                    let noDataError = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    single(.failure(noDataError))
                    return
                }

                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decodedObject))
                } catch {
                    single(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
