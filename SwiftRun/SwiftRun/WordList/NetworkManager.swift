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
            print("🔍 [Network Request] URL: \(url.absoluteString)") // 요청 URL 로그
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // 에러 처리
                if let error = error {
                    print("❌ [Network Error]: \(error.localizedDescription)")
                    single(.failure(error))
                    return
                }

                // HTTP 상태 코드 확인
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                    print("⚠️ [Invalid Response]: \(response.debugDescription)")
                    single(.failure(statusCodeError))
                    return
                }

                // 데이터 유효성 확인
                guard let data = data else {
                    let noDataError = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    print("⚠️ [No Data]: No data returned from the server.")
                    single(.failure(noDataError))
                    return
                }

                // JSON 디코딩 처리
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    print("✅ [Decoding Success]: \(T.self) fetched successfully.")
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
