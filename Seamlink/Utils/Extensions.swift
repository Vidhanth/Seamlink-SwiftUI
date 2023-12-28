//
//  Extensions.swift
//  Seamlink
//
//  Created by Vidhanth on 25/12/23.
//

import Foundation

extension String {
    func extractURLs() -> [URL] {
        let urlRegex = try! NSRegularExpression(pattern: "(https?|ftp)://[^\\s/$.?#].[^\\s]*", options: .caseInsensitive)
        
        let matches = urlRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        let validURLs = matches.compactMap { match -> URL? in
            guard let range = Range(match.range, in: self) else { return nil }
            return URL(string: String(self[range]))
        }
        
        return validURLs
    }
    
    
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isYoutubeLink : Bool {
        self.lowercased().contains("youtube.com/") || self.lowercased().contains("youtu.be/")
    }
    
    
}
