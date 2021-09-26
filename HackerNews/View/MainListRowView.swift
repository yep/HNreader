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

struct MainListRowView: View {
    let newsItem: NewsItemModel
    private static let dateFormatter = RelativeDateTimeFormatter()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: CommentsView(viewModel: CommentsViewModel(newsItem: newsItem))) {
                    Text(newsItem.title)
                        .lineLimit(nil)
                        .foregroundColor(.primary)
                        .padding([.bottom, .trailing], 2)
                }
                if newsItem.text != "" {
                    Text(newsItem.textPreview)
                        .lineLimit(nil)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(newsItem.url)
                    .lineLimit(nil)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
                InfoView(newsItem: newsItem)
            }
        }
    }
}

#if DEBUG
struct MainListRowViewPreviews : PreviewProvider {
    static var previews: some View {
        return Group {
            Group {
                MainListRowView(newsItem: NewsItemModel.mock())
                MainListRowView(newsItem: NewsItemModel.mockLongText())
            }
            .previewLayout(.fixed(width: 300, height: 300))
        }
    }
}
#endif

