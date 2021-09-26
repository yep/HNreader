//
//  Copyright (c) 2019 woxtu
//  Copyright (c) 2019-2021 Jahn Bertsch
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    var loading = false
    var feedType = FeedType.top {
        didSet {
            newsItems.removeAll()
            fetchFeed(type: feedType)
        }
    }
    @Published var newsItems = [NewsItemModel]()
    
    private let itemsPerPage = 12
    private var fetchFeedCancellable: Cancellable?
    private var feed = [Int]() {
        didSet {
            fetchItems(ids: feed.prefix(itemsPerPage))
        }
    }
    
    deinit {
        fetchFeedCancellable?.cancel()
    }
    
    func viewDidAppear() {
        self.reloadFeed()
    }
    
    func loadMoreStories() {
        let ids = self.feed.dropFirst(self.newsItems.count).prefix(self.itemsPerPage)
        self.fetchItems(ids: ids)
    }

    func reloadFeed() {
        self.loading = false // force re-fetch
        self.newsItems.removeAll()
        self.objectWillChange.send()
        self.fetchFeed(type: self.feedType)
    }
    
    private func fetchFeed(type: FeedType) {
        fetchFeedCancellable = FetchFeed(type: type).sink(receiveCompletion: { _ in }, receiveValue: {
            self.feed = $0
        })
    }
    
    private func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        guard !loading else {
            return
        }
        loading = true
        
        fetchFeedCancellable = Publishers.MergeMany(ids.map {
            FetchItem(id: $0)
        })
        .collect()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.newsItems = self.newsItems + $0
            self.loading = false
        })
    }
}

#if DEBUG
extension MainViewModel {
    class func mock() -> MainViewModel {
        let viewModel = MainViewModel()
        viewModel.newsItems = [NewsItemModel.mock(), NewsItemModel.mockLongText()]
        return viewModel
    }
}
#endif
