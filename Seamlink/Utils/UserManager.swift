//
//  UserManager.swift
//  Seamlink
//
//  Created by Vidhanth on 28/12/23.
//

import Foundation
import Supabase

struct TagsResponse: Decodable {
    let tags: [String]
}

class UserManager {
    
    static let shared: UserManager = UserManager()
    
    var client: PostgrestClient {
        Client.shared.client.database
    }
        
    func getTags(userId: UUID) async throws -> [String] {
        let tags: [TagsResponse] = try await client
            .from("user_data")
            .select("tags")
            .eq("id", value: userId)
            .execute()
            .value
        return tags.first?.tags ?? []
    }
    
    
}
