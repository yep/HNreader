//
//  LinkButton.swift
//  HNreader
//

import SwiftUI
import AuthenticationServices

struct LinkButton: View {
    @State var url: URL
    @State var safariViewIsPresented = false

    var body: some View {
        Button(action: {
            #if os(watchOS)
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: nil) { _, _ in }
            session.prefersEphemeralWebBrowserSession = true
            session.start()
            #else
            safariViewIsPresented = true
            #endif
        }) {
            Text(url.absoluteString)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .font(.subheadline)
        }
        #if os(watchOS)
        .buttonStyle(.plain)
        .foregroundStyle(.accent)
        #else
        .padding(0)
        .sheet(
            isPresented: $safariViewIsPresented,
            onDismiss: {
                self.safariViewIsPresented = false
        }, content: {
            SafariView(url: url)
        })
        #endif
    }
}

#Preview {
    LinkButton(url: URL(string: "https://example.com")!)
    .frame(width: 300, height: 500)
}


