//
//  Based on stack overflow answer by user "aamirr"
//  https://stackoverflow.com/a/47480859
//  https://stackoverflow.com/users/1244597/aamirr
//

import Foundation

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        
        return decoded ?? self
    }
    
    var removeNewline: String {
        if hasSuffix("\n") {
           return String(dropLast() + " ")
        } else {
            return self
        }
    }
}
