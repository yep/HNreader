//
//  CommentView.swift
//  HNreader
//

import SwiftUI

struct CommentView: View {
    var viewModel = NewsItemModel()
    @State var id: Int
    @State var expanded = false
    
    var body: some View {
        VStack {
            if let error = viewModel.error {
                Text(error)
            } else if let commentText = viewModel.newsItem?.text,
               commentText != ""
            {
                LeftAlignedText(commentText)
                .padding(.top)
                
                AuthorView(viewModel: viewModel)
                
                if expanded,
                   let kids = viewModel.newsItem?.kids,
                   kids.count > 0
                {
                    ForEach(viewModel.newsItem?.kids ?? [], id: \.self) { kidId in
                        CommentView(id: kidId)
                            .padding(.leading)
                    }
                }
            }
        }
        .background(expanded ? Color.primary.opacity(0.03) : Color.clear)
        .onAppear {
            viewModel.fetch(id: id)
        }
        .onTapGesture {
            expanded.toggle()
        }
    }
}

#Preview {
    CommentView(id: 43760801)
        .frame(width: 300, height: 500)
}


