//
//  LeftAlignedText.swift
//  HNreader
//

import SwiftUI

struct LeftAlignedText: View {
    @State var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(text)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    LeftAlignedText("Test")
        .background(.purple)
        .frame(width: 300, height: 500)
}


