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

struct CommentsView: View {
    @ObservedObject var viewModel: CommentsViewModel

    var body: some View {
        List {
            NavigationLink(destination: PreviewView(viewModel: PreviewViewModel(newsItem: viewModel.newsItem))) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.viewModel.newsItem.title)
                        .foregroundColor(.defaultColor)
                        .lineLimit(nil)
                        .font(.title)
                    
                    Text(viewModel.newsItem.url)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .font(.caption)
                        .padding(.top)
                    
                    InfoView(newsItem: viewModel.newsItem)
                        .padding([.top, .bottom], CGFloat.sectionPadding)
                }
            }
            
            if viewModel.loading {
                Text("Loading comments, please wait…")
                    .foregroundColor(.primary)
            } else if viewModel.comments(for: viewModel.newsItem).isEmpty {
                Text("No Comments")
                    .foregroundColor(.primary)
            } else {
                ForEach(viewModel.comments(for: viewModel.newsItem)) { (newsItem: NewsItemModel) in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(newsItem.text)
                            .lineLimit(nil)
                            .foregroundColor(.primary)
                            .padding([.top, .bottom], CGFloat.defaultPadding)
                            .padding([.leading], newsItem.depth * CGFloat.sectionPadding)
                        InfoView(newsItem: newsItem)
                            .padding([.bottom], CGFloat.defaultPadding)
                            .padding([.leading], newsItem.depth * CGFloat.sectionPadding)
                    }
                    .onTapGesture(perform: {
                        viewModel.loadChildren(of: newsItem)
                    })
                    .contextMenu {
                        ForEach(viewModel.getUrlModels(for: newsItem)) { (urlModel: UrlModel) in
                            Button {
                                UIApplication.shared.open(urlModel.url, options: [:], completionHandler: nil)
                            } label: {
                                Text(urlModel.urlString)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .id(viewModel.newsItem.id)
        .navigationBarTitle(Text("Comments"), displayMode: .inline)
        .onAppear {
            self.viewModel.viewDidAppear()
        }
    }
}

#if DEBUG
struct CommentsView_Previews : PreviewProvider {
    static var previews: some View {
        let viewModel = CommentsViewModel(newsItem: NewsItemModel.mockLongText())
        viewModel.kids = [1: [NewsItemModel.mock()],
                          2: [NewsItemModel.mock()],
                          3: [NewsItemModel.mock()]]
        
        return Group {
            CommentsView(viewModel: viewModel)
                .environment(\.colorScheme, .dark)
            CommentsView(viewModel: viewModel)
                .environment(\.colorScheme, .light)
        }
    }
}
#endif


