//
//  AuthorView.swift
//  HNreader
//

import SwiftUI

struct AuthorView: View {
    @State var viewModel = NewsItemModel()
    
    var body: some View {
        HStack {
            Text(viewModel.newsItem?.commentInfoString ?? "")
                .font(.footnote)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
    }
}
