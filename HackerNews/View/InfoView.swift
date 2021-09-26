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

struct InfoView: View {
    let newsItem: NewsItemModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: "bubble.right")
            Text("\(newsItem.kids.count)")
            if newsItem.score > 0 {
                Image(systemName: "hand.thumbsup")
                Text("\(newsItem.score)")                
            }
            Image(systemName: "clock")
            Text(newsItem.relativeTimeString)
            Image(systemName: "person")
            Text(newsItem.by)
            Spacer()
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}

#if DEBUG
struct InfoViewViewPreviews : PreviewProvider {
    static var previews: some View {
        return Group {
            Group {
                InfoView(newsItem: NewsItemModel.mock())
                InfoView(newsItem: NewsItemModel.mockLongText())
            }
            .previewLayout(.fixed(width: 300, height: 300))
        }
    }
}
#endif
