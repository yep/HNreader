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
import SwiftLinkPreview

struct PreviewView: View {
    @ObservedObject var viewModel: PreviewViewModel
    @State var safariViewIsPresented = false
    
    var body: some View {
        List {
            Button(action: {
                safariViewIsPresented = true
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.newsItem.title)
                        .foregroundColor(.defaultColor)
                        .lineLimit(nil)
                        .font(.title)
                    
                    Text(viewModel.newsItem.url)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .font(.caption)
                        .padding(.top)

                    self.viewModel.image.map {
                        Image(uiImage: $0)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top)
                    }
                    
                    if viewModel.newsItem.text != "" {
                        Text(viewModel.newsItem.text)
                            .foregroundColor(.primary)
                            .padding([.top, .bottom], CGFloat.sectionPadding)
                            .lineLimit(nil)
                            .padding(.top)
                    }
                    
                    Text(viewModel.description)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .padding(.top)
                }
            }.sheet(
                isPresented: $safariViewIsPresented,
                onDismiss: {
                    self.safariViewIsPresented = false
            }, content: {
                SafariView(urlString: self.viewModel.newsItem.url, entersReaderIfAvailable: true)
            })
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Text("Preview"), displayMode: .inline)
        .onAppear {
            self.viewModel.viewDidAppear()
        }
    }
}

#if DEBUG
struct NewsItemViewPreviews : PreviewProvider {
    static var previews: some View {
        let previewViewModel = PreviewViewModel(newsItem: NewsItemModel.mockLongText())
        if let image = UIImage(named: "AppIcon") {
            previewViewModel.image = image
        }
        return PreviewView(viewModel: previewViewModel)
    }
}
#endif

