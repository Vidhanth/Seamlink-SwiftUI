//
//  SeamlinkApp.swift
//  Seamlink
//
//  Created by Vidhanth on 14/11/23.
//

import SwiftUI

@main
struct SeamlinkApp: App {
    
    var currentSession = CurrentSession()
    
    var body: some Scene {
        WindowGroup {
            Seamlink()
                .environmentObject(currentSession)
        }
    }
}
