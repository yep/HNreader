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
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let urlString: String
    let entersReaderIfAvailable: Bool
    
    func makeUIViewController(context: Context) -> SFSafariViewController  {
        let url = URL(string: urlString) ?? URL(string: "http://news.ycombinator.com")!
        
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredControlTintColor = .defaultColor
        
        return safariViewController
    }
    
    func updateUIViewController(_ uiView: SFSafariViewController, context: Context) {}
}

#if DEBUG
struct WebViewPreviews : PreviewProvider {
    static var previews: some View {
        return SafariView(urlString: "http://news.ycombinator.com", entersReaderIfAvailable: true)
    }
}
#endif

