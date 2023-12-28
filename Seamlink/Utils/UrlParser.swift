//
//  UrlParser.swift
//  Seamlink
//
//  Created by Vidhanth on 25/12/23.
//

import Foundation
import Kanna

class UrlParser {
    
    static let shared: UrlParser = UrlParser()
    
    func getTitle(from url: URL) -> String {
        
        
        if let doc = try? HTML(url: url, encoding: .utf8) {            
            return doc.title ?? ""
        }
        
        
        return ""
    }
    
}

