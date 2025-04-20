//
//  SafariView.swift
//  HNreader
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url: URL?
    
    func makeUIViewController(context: Context) -> SFSafariViewController  {
        var actualURL: URL
        if let url = url {
            actualURL = url
        } else {
            actualURL = URL(string: "http://news.ycombinator.com")!
        }
        
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        
        let safariViewController = SFSafariViewController(url: actualURL, configuration: configuration)
        
        #if os(ipadOS)
        // disabled on ipadOS to fix compilation for visionOS
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredControlTintColor = .tintColor
        #endif
        
        return safariViewController
    }
    
    func updateUIViewController(_ uiView: SFSafariViewController, context: Context) {}
}
