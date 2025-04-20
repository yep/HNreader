//
//  BaseViewModel.swift
//  HNreader
//

import Foundation
import OSLog

@Observable class BaseModel {
    internal static let jsonDecoder = JSONDecoder()
    internal static let queue = OperationQueue()
    internal var error: String?

    func fetch(url: URL?, cachePolicy: NSURLRequest.CachePolicy, completion: @escaping (Data) -> Void) {
        guard let url = url else {
            return
        }
        
        error = nil
        var request = URLRequest(url: url)
        request.cachePolicy = cachePolicy
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let response = response as? HTTPURLResponse else {
                self.error = "No HTTP response received"
                Logger.shared.log(level: .default, "\(self.error ?? "")")
                return
            }
            guard let data = data else {
                self.error = "No HTTP data received"
                Logger.shared.log(level: .default, "\(self.error ?? "")")
                return
            }
            guard response.statusCode == 200 else {
                self.error = "Request failed with status code: \(response.statusCode)"
                Logger.shared.log(level: .default, "\(self.error ?? "")")
                return
            }
            
            completion(data)
        }
        dataTask.resume()
    }
}
