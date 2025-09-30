//
//  NewsItemModel.swift
//  HNreader
//

import Foundation
import AuthenticationServices
import OSLog
import UIKit

@Observable class NewsItemModel: BaseModel {
    var feedType: FeedType = .top
    var newsItem: NewsItem?
    
    override init() {
        #if os(watchOS)
        Self.queue.maxConcurrentOperationCount = 4
        #endif
    }
    
    func fetch(id: Int) {
        Self.queue.addOperation {
            self.fetch(url: URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json"), cachePolicy: .returnCacheDataElseLoad, completion: { data in
                if let newsItem = try? Self.jsonDecoder.decode(NewsItem.self, from: data) {
                    self.newsItem = newsItem
                } else {
                    Logger.shared.log(level: .default, "decode news item failed: \(String(data: data, encoding: .utf8) ?? "empty")")
                    print("decode news item failed")
                }
            })
        }
    }
}
