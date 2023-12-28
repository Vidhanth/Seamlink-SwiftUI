//
//  Seamlink.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import SwiftUI

struct Seamlink: View {
        
    @EnvironmentObject var currentSession: CurrentSession
    
    var body: some View {
        if (currentSession.session == nil) {
            AuthView()
                .environmentObject(currentSession)
        } else {
            NoteListView()
                .environmentObject(currentSession)
        }
    }
}

#Preview {
    Seamlink()
        .environmentObject(CurrentSession())
}
