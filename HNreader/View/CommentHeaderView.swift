//
//  CommentHeaderView.swift
//  HNreader
//

import SwiftUI

struct CommentHeaderView: View {
    @State var viewModel: NewsItemModel
    
    var body: some View {
        if let error = viewModel.error {
            Text(error)
        } else {
            VStack {
                if let title = viewModel.newsItem?.title {
                    LeftAlignedText(title)
                    #if os(watchOS)
                    .font(.title3)
                    #else
                    .font(.title)
                    #endif
                }
                
                if let url = viewModel.newsItem?.url {
                    HStack() {
                        #if targetEnvironment(macCatalyst)
                        Link(url.absoluteString, destination: url)
                        #else
                        LinkButton(url: url)
                        #endif
                        Spacer()
                    }
                }
                
                if let text = viewModel.newsItem?.text {
                    LeftAlignedText(text)
                }
                
                AuthorView(viewModel: viewModel)
            }
            .padding([.leading, .trailing])
        }
    }
}


