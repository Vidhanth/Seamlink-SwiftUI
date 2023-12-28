//
//  Result.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import Foundation

struct Result {
        
    let success: Bool
    let message: String?
    let payload: Any?
    
    init(success: Bool, message: String? = "", payload: Any? = nil) {
        self.success = success
        self.message = message
        self.payload = payload
    }
    
}
