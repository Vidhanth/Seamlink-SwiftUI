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
    var tags : [String] = []
    
    var isActive: Bool {
        if session != nil {
            return true
        }
        return false
    }
    
    var user : User? {
        session?.user
    }
    
    func createSession(session: Session) async {
        
        do {
            tags = try await UserManager.shared.getTags(userId: session.user.id)
        } catch {
            print("error \(error)")
            tags = []
        }
        DispatchQueue.main.async {
            withAnimation {
                self.session = session
            }
        }
    }
    
    func endSession() {
        self.session = nil
        tags = []
    }
    
}
