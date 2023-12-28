//
//  AuthManager.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import Foundation

class AuthManager {
    
    static let shared: AuthManager = AuthManager()
    
    let auth = Client.shared.client.auth
    
    func signUp(email: String, password: String) async -> Result {
        do {
            let response = try await auth.signUp(
                email: email,
                password: password
            )
            StorageManager.shared.storeCredentials(email: email, password: password)
            return Result(success: true, payload: response.session)
        } catch {
            print(error.localizedDescription)
            return Result(success: false, message: error.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String) async -> Result {
        do {
            let session = try await auth.signIn(
                email: email,
                password: password
            )
            StorageManager.shared.storeCredentials(email: email, password: password)
            return Result(success: true, payload: session)
        } catch {
            print(error.localizedDescription)
            return Result(success: false, message: error.localizedDescription)
        }
    }
    
    func attemptSignIn() async -> Result {
        do {
            let credentials = StorageManager.shared.retrieveCredentials()
            guard let credentials else { return Result(success: false) }
            
            print("Attempting to sign in : \(credentials.email)")
            
            let session = try await auth.signIn(
                email: credentials.email,
                password: credentials.password
            )
            return Result(success: true, payload: session)
        } catch {
            StorageManager.shared.clearCredentials()
            print(error.localizedDescription)
            return Result(success: false, message: error.localizedDescription)
        }
    }
    
    func signOut() async {
        do {
            try await auth.signOut()
            StorageManager.shared.clearCredentials()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
