//
//  Session.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import SwiftUI
import Auth

final class CurrentSession: ObservableObject {
        
    @Published var session : Session?
    
    var isActive: Bool {
        if session != nil {
            return true
        }
        return false
    }
    
    var user : User? {
        session?.user
    }
    
    func createSession(session: Session) {
        self.session = session
    }
    
    func endSession() {
        self.session = nil
    }
    
}
