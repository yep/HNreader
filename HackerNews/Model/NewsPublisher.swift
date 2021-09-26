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
import Foundation

enum FeedType: String, CaseIterable {
    case top
    case new
    case show
    case ask
}

struct FetchFeed: Publisher {
    typealias Output = [Int]
    typealias Failure = Error
    
    let type: FeedType
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        if let url = URL(string: "https://hacker-news.firebaseio.com/v0/\(type.rawValue)stories.json") {
            let request = URLRequest(url: url)
            URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
                .map { $0.0 }
                .decode(type: [Int].self, decoder: JSONDecoder())
                .receive(subscriber: subscriber)
        }
    }
}

struct FetchItem: Publisher {
    typealias Output = NewsItemModel
    typealias Failure = Error
    let id: Int
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        if let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") {
            let request = URLRequest(url: url)
            URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
                .map { $0.0 }
                .decode(type: NewsItemModel.self, decoder: JSONDecoder())
                .receive(subscriber: subscriber)
        }
    }
}
