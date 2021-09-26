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

import Combine
import SwiftUI
import SwiftLinkPreview

final class PreviewViewModel: ObservableObject {
    let newsItem: NewsItemModel
    var commentsUrlString = ""
    var description = "Loading preview, please wait…"
    var images: [String] = []
    var image: UIImage?

    private static let linkPreview = SwiftLinkPreview(session: URLSession.shared, workQueue: SwiftLinkPreview.defaultWorkQueue, responseQueue: DispatchQueue.main, cache: InMemoryCache())
    
    init(newsItem: NewsItemModel) {
        self.newsItem = newsItem
        self.commentsUrlString = newsItem.commentUrl?.absoluteString ?? ""
    }
    
    func viewDidAppear() {
        guard self.newsItem.url != "" else {
            self.description = ""
            self.objectWillChange.send()
            return
        }
        
        if let cachedResponse = Self.linkPreview.cache.slp_getCachedResponse(url: self.newsItem.url) {
            self.handle(cachedResponse)
        } else {
            Self.linkPreview.preview(self.newsItem.url, onSuccess: { (response: Response) in
                self.handle(response)
            }, onError: { error in
                dLog("error: \(error)")
            })
        }
    }
    
    private func handle(_ response: Response) {
        if let description = response.description {
            self.description = description.appending("\n\n[Press to open URL]")
        }
        if let images = response.images {
            self.images = images
        }
        if let imageUrlString = response.image,
            let imageUrl = URL(string: imageUrlString)
        {
            fetchImage(imageUrl)
        }
        
        self.objectWillChange.send()
    }
    
    private func fetchImage(_ imageUrl: URL) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                self.image = image
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }.resume()
    }
}
