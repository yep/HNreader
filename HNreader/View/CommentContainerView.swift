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
                CommentHeaderView(viewModel: viewModel)

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
            
            Button {
                viewModel.newsItem = nil
                viewModel.fetch(id: id)
            } label: {
                ReloadView()
            }
            .padding()
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
