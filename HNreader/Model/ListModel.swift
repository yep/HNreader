//
//  ListViewModel.swift
//  HNreader
//

import Foundation

@Observable class ListModel: BaseModel {
    let feedType: FeedType
    var newsItemIDs: [Int] = []
        
    init(feedType: FeedType) {
        self.feedType = feedType
    }
    
    func fetchNewsItems(forceReload: Bool = false) {
        if !forceReload && newsItemIDs.count > 0 {
            return
        }
        
        cancelAllOperations()
        newsItemIDs = []
        fetch(url: URL(string: "https://hacker-news.firebaseio.com/v0/\(feedType.rawValue)stories.json"), cachePolicy: .reloadRevalidatingCacheData, completion: { data in
            if let newsItemIDs = try? Self.jsonDecoder.decode([Int].self, from: data) {
                for newsItemID in newsItemIDs {
                    self.newsItemIDs.append(newsItemID)
                }
            }
        })
    }
    
    func cancelAllOperations() {
        Self.queue.cancelAllOperations()
    }
}
