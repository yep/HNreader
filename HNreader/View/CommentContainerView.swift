//
//  CommentContainerView.swift
//  HNreader
//

import SwiftUI

struct CommentContainerView: View {
    @State var viewModel = NewsItemModel()
    @State var id: Int

    var body: some View {
        ScrollView {
            VStack {
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

                if let kids = viewModel.newsItem?.kids,
                   kids.count > 0
                {
                    ForEach(viewModel.newsItem?.kids ?? [], id: \.self) { commentId in
                        CommentView(id: commentId)
                            .padding(.leading)
                    }
                }
            }
            .padding([.top, .trailing])
            
            Button("Reload") {
                viewModel.newsItem = nil
                viewModel.fetch(id: id)
            }
            .padding(.top)
        }
        .onAppear {
             viewModel.fetch(id: id)
        }
    }
}

#Preview {
    CommentContainerView(id: 1)
    .frame(width: 300, height: 500)
}


