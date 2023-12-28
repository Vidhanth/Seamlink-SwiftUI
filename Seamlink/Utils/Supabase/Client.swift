//
//  Client.swift
//  Seamlink
//
//  Created by Vidhanth on 23/12/23.
//

import Supabase
import Foundation


class Client {
        
    static var shared : Client = Client()
    let client = SupabaseClient(supabaseURL: URL(string: Secrets.databaseURL)!, supabaseKey: Secrets.secretKey)
    
}
