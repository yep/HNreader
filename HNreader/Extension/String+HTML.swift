//
//  Based on stack overflow answer by user "aamirr"
//  https://stackoverflow.com/a/47480859
//  https://stackoverflow.com/users/1244597/aamirr
//

import Foundation

extension String {
    var htmlDecoded: String {
        let attributedString = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
        
        var result = attributedString?.string ?? self
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return result
    }
}
