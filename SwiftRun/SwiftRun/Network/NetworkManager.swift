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
            print("🔍 Requesting URL: \(url.absoluteString)") // 요청 URL 로그
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("❌ [Network Error]: \(error.localizedDescription)")
                    single(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let invalidResponseError = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                    print("⚠️ [Response Error]: No HTTP response received.")
                    single(.failure(invalidResponseError))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "InvalidStatusCode", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Status Code: \(httpResponse.statusCode)"])
                    print("⚠️ [Status Code Error]: \(httpResponse.statusCode)")
                    single(.failure(statusCodeError))
                    return
                }

                guard let data = data else {
                    let noDataError = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server."])
                    print("⚠️ [No Data]: No data returned from the server.")
                    single(.failure(noDataError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let decodedObject = try decoder.decode(T.self, from: data)
                    print("✅ [Decoding Success]: \(decodedObject)")
                    single(.success(decodedObject))
                } catch {
                    print("❌ [Decoding Error]: \(error.localizedDescription)")
                    single(.failure(error))
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
                print("🛑 [Request Canceled]: \(url.absoluteString)")
            }
        }
    }
}
