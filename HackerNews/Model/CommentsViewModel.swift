//
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

import SwiftUI
import Combine

final class CommentsViewModel: ObservableObject {
    let newsItem: NewsItemModel
    var kids = [Int: [NewsItemModel]]()
    var loading = true

    private var fetchItemsCancellable: Cancellable?

    init(newsItem: NewsItemModel) {
        self.newsItem = newsItem
    }
    
    func viewDidAppear() {
        if self.kids.isEmpty {
            self.loadChildren(of: newsItem)
        }
    }
    
    func comments(for newsItem: NewsItemModel) -> [NewsItemModel] {
        if let kids = kids[newsItem.id] {
            var result = [NewsItemModel]()
            
            for var kid in kids {
                kid.depth = newsItem.depth + 1
                result.append(kid)
                result += comments(for: kid)
            }
            
            return result
        } else {
            return []
        }
    }
    
    func loadChildren(of newsItem: NewsItemModel) {
        if kids[newsItem.id] != nil {
            // hide comments
            kids[newsItem.id] = nil
            self.objectWillChange.send()
        } else if newsItem.kids.isEmpty {
            // no comments
            loading = false
            self.objectWillChange.send()
        } else {
            // load comments
            fetchItemsCancellable = Publishers.MergeMany(newsItem.kids.map {
                FetchItem(id: $0)
            })
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                self.kids[newsItem.id] = $0
                self.loading = false
                self.objectWillChange.send()
            })
        }
    }
    
    func getUrlModels(for newsItem: NewsItemModel) -> [UrlModel] {
        var result: [UrlModel] = []
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        if let matches = detector?.matches(in: newsItem.text, options: [], range: NSRange(location: 0, length: newsItem.text.utf16.count)) {
            var index = 0
            for match in matches {
                guard let range = Range(match.range, in: newsItem.text) else {
                    continue
                }
                
                if let url = URL(string: String(newsItem.text[range])) {
                    var urlString = newsItem.text[range]
                    
                    if urlString.hasPrefix("https://") {
                        urlString = urlString.dropFirst(8)
                    } else if urlString.hasPrefix("http://") {
                        urlString = urlString.dropFirst(7)
                    }
                    if urlString.hasSuffix("/") {
                        urlString = urlString.dropLast()
                    }
                    result.append(UrlModel(id: index, url: url, urlString: String(urlString)))
                    index += 1
                }
            }
        }

        return result
    }
}
