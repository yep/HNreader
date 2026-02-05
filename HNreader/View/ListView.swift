//
//  NewsListView.swift
//  HNreader
//

import SwiftUI

struct ListView: View {
    @State var viewModel: ListModel

    var body: some View {
        ScrollViewReader { proxy in
            List {
                Button {
                    viewModel.fetchNewsItems(forceReload: true)
                } label: {
                    ReloadView()
                }
                
                ForEach(viewModel.newsItemIDs, id: \.self) { id in
                    NavigationLink(destination: CommentContainerView(id: id)) {
                        ListItemView(id: id)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchNewsItems()
        }
        .onDisappear {
            viewModel.cancelAllOperations()
        }
    }
}

#Preview {
    ListView(viewModel: ListModel(feedType: .top))
    .frame(width: 300, height: 500)
}

