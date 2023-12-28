//
//  SettingsView.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var currentSession: CurrentSession
    @State var isLoading = false
    
    var body: some View {
            Form {
                Section (header: Text("Account")) {
                    Button {
                        withAnimation {
                            isLoading = true
                        }
                        Task {
                            await AuthManager.shared.signOut()
                            currentSession.endSession()
                        }
                        withAnimation {
                            isLoading = false
                        }
                    } label: {
                        HStack {
                            Text(isLoading ? "Signing Out.." : "Sign Out")
                                .foregroundStyle(.red)
                            if (isLoading) {
                                ProgressView()
                                    .tint(.red)
                                    .padding(.leading, 1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        
    }
}

#Preview {
    SettingsView()
}
