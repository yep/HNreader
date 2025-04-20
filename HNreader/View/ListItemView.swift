//
//  ListItemView.swift
//  HNreader
//

import SwiftUI

struct ListItemView: View {
    @State var viewModel = NewsItemModel()
    @State var id: Int
    
    var body: some View {
        VStack {
            if let error = viewModel.error {
                Text(error)
            } else {
                HStack {
                    Text(viewModel.newsItem?.title ?? "")
                    Spacer()
                }
                HStack {
                    Text(viewModel.newsItem?.commentInfoString ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
        }
        .onAppear {
             viewModel.fetch(id: id)
        }
    }
}

#Preview {
    ListItemView(id: 1).frame(width: 300, height: 500)
}


