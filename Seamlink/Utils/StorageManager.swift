//
//  StorageManager.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import SwiftUI

final class StorageManager {
    
    static let shared: StorageManager = StorageManager()
    
    @AppStorage("credentials") private var credentials: Data?
    
    func storeCredentials(email: String, password: String) {
        do {
            try credentials = JSONEncoder().encode(Credentials(email: email, password: password))
        } catch {
            print(error)
        }
    }
    
    func retrieveCredentials() -> Credentials? {
        guard let credentials else { return nil }
        do {
            let creds = try JSONDecoder().decode(Credentials.self, from: credentials)
            return creds
        } catch {
            print(error)
            return nil
        }
    }
    
    func clearCredentials() {
        credentials = nil
    }
    
    
}
