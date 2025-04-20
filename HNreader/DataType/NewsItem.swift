//
//  NewsItem.swift
//  HNreader
//

import SwiftUI

struct NewsItem: Identifiable {
    let id:           Int
    let parent:       Int
    let time:         Date
    let descendants:  Int
    let kids:         [Int]
    let by:           String
    let score:        Int
    let title:        String?
    let text:         String?
    let url:          URL?
    let relativeTime: String
    let commentUrl:   URL?
    
    var commentInfoString: String {
        var result = "\(relativeTime) • \(by)"
        if kids.count == 1 {
            result += " • 1 child"
        } else if kids.count > 1 {
            result += " • \(kids.count) children"
        }
        return result
    }
    
    private static let dateFormatter = RelativeDateTimeFormatter()
    
    init(id: Int) {
        self.id      = id
        by           = ""
        parent       = 0
        descendants  = 0
        kids         = []
        score        = 0
        time         = Date()
        title        = nil
        text         = nil
        url          = nil
        relativeTime = ""
        commentUrl   = nil
    }
}

extension NewsItem: Codable {
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)

        id           = try container.decode(Int.self, forKey: .id)
        parent       = try container.decodeIfPresent(Int.self, forKey: .parent) ?? 0
        by           = try container.decodeIfPresent(String.self, forKey: .by) ?? ""
        descendants  = try container.decodeIfPresent(Int.self, forKey: .descendants) ?? 0
        kids         = try container.decodeIfPresent([Int].self, forKey: .kids) ?? []
        score        = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
        
        let time     = try container.decodeIfPresent(Int.self, forKey: .time) ?? 0
        self.time    = Date(timeIntervalSince1970: TimeInterval(time))

        let title    = try container.decodeIfPresent(String.self, forKey: .title)
        self.title   = title?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let text     = try container.decodeIfPresent(String.self, forKey: .text)
        self.text    = text?.htmlDecoded ?? nil

        let url      = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.url     = URL(string: url)
        relativeTime = Self.dateFormatter.string(for: self.time) ?? ""
        commentUrl   = URL(string: "https://news.ycombinator.com/item?id=\(id)")
    }
}
