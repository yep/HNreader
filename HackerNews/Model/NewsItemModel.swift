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

import SwiftUI

struct NewsItemModel: Identifiable {
    let by: String
    let id: Int
    let parent: Int
    let kids: [Int]
    let score: Int
    let time: Date
    let title: String
    let text: String
    var textPreview: String {
        get {
            return String(text.prefix(Self.textPreviewLength))
        }
    }
    let url: String
    let relativeTimeString: String
    let commentInfoString: String
    let commentUrl: URL?
    let commentUrlString: String
    var depth: CGFloat = -1
    
    private static let dateFormatter = RelativeDateTimeFormatter()
    private static let textPreviewLength = 150
}

extension NewsItemModel: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // TODO: fix this do/catch parade
        
        do {
            by = try container.decode(String.self, forKey: .by)
        } catch {
            by = ""
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch {
            id = 0
        }
        
        do {
            parent = try container.decodeIfPresent(Int.self, forKey: .parent) ?? 0
        } catch {
            parent = 0
        }
        
        do {
            kids = try container.decodeIfPresent([Int].self, forKey: .kids) ?? []
        } catch {
            kids = []
        }
        
        do {
            score = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
        } catch {
            score = 0
        }
        
        do {
            let decodedTime = try container.decodeIfPresent(Int.self, forKey: .time) ?? 0
            time = Date(timeIntervalSince1970: TimeInterval(decodedTime))
        } catch {
            time = Date()
        }
        
        do {
            title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        } catch {
            title = ""
        }

        do {
            let textHtmlEntities = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
            text = textHtmlEntities.htmlDecoded.removeNewline
        } catch {
            text = ""
        }
        
        do {
            url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        } catch {
            url = ""
        }
        
        relativeTimeString = Self.dateFormatter.string(for: time) ?? ""
        commentInfoString = "\(relativeTimeString) • \(by) • \(kids.count) children"
        commentUrl = URL(string: "https://news.ycombinator.com/item?id=\(id)")
        commentUrlString = commentUrl?.absoluteString ?? ""
    }
}

extension NewsItemModel: Equatable {
    static func == (lhs: NewsItemModel, rhs: NewsItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

#if DEBUG
extension NewsItemModel {
    static func mock() -> NewsItemModel {
        return NewsItemModel(by: "author",
                             id: 1,
                             parent: 0,
                             kids: [],
                             score: 1,
                             time: Date().addingTimeInterval(-60),
                             title: "Title",
                             text: "Text",
                             url: "http://example.com",
                             relativeTimeString: "1 hour ago",
                             commentInfoString: "1 children",
                             commentUrl: URL(string: "https://news.ycombinator.com/item?id=1"),
                             commentUrlString: "https://news.ycombinator.com/item?id=1")
    }
    
    static func mockLongText() -> NewsItemModel {
        return NewsItemModel(by: "author",
                             id: 2,
                             parent: 1,
                             kids: [],
                             score: 2,
                             time: Date().addingTimeInterval(-120),
                             title: "Very long title. Very long title. Very long title. Very long title. Very long title. Very long title. Very long title. Very long title.",
                             text: "Very long text. Very long text. Very long text. Very long text. Very long text. Very long text. ",
                             url: "http://example.com/very-long-url/very-long-url/very-long-url/very-long-url",
                             relativeTimeString: "1 hour ago",
                             commentInfoString: "3 children",
                             commentUrl: URL(string: "https://news.ycombinator.com/item?id=1"),
                             commentUrlString: "https://news.ycombinator.com/item?id=1")
    }
}
#endif

