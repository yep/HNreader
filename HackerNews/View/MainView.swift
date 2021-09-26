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

struct MainView : View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingInfo = false
    fileprivate static let aboutText = "\nUse long press to open links mentioned in comments.\n⏤\nCopyright (c) 2021 Jahn Bertsch\nCopyright (c) 2019 woxtu\nCopyright (c) 2016 Leonardo Cardoso\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.newsItems.isEmpty {
                    List {
                        Text("Loading, please wait…")
                            .foregroundColor(.primary)
                            .padding()
                    }.listStyle(PlainListStyle())
                } else {
                    List {
                        ForEach(viewModel.newsItems) { newsItem in
                            MainListRowView(newsItem: newsItem)
                        }
                        HStack {
                            Spacer()
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .defaultColor))
                            Spacer()
                        }.onAppear {
                            self.viewModel.loadMoreStories()
                        }
                    }.listStyle(PlainListStyle())
                }
                
                Picker("", selection: $viewModel.feedType) {
                    ForEach(FeedType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(CGFloat.defaultPadding)
                .foregroundColor(.defaultColor)
            }
            .navigationBarTitle(Text(viewModel.feedType.rawValue.capitalized), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showingInfo = true
            }) {
                Image(systemName: "info.circle.fill")
            }, trailing:
                Button(action: {
                    self.viewModel.reloadFeed()
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                }
            )
            .foregroundColor(.defaultColor)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingInfo) {
            Alert(title: Text("About"), message: Text(Self.aboutText), dismissButton: nil)
        }
        .onAppear {
            self.viewModel.viewDidAppear()
        }
    }
}

#if DEBUG
struct MainViewPreviews : PreviewProvider {
    static var previews: some View {
        Group {
            MainView(viewModel: MainViewModel.mock())
                .environment(\.colorScheme, .dark)
            MainView(viewModel: MainViewModel.mock())
                .environment(\.colorScheme, .light)
        }
    }
}
#endif





