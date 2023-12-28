//
//  NotesManager.swift
//  Seamlink
//
//  Created by Vidhanth on 26/12/23.
//

import Foundation
import Supabase

class NotesManager {
    
    static let shared: NotesManager = NotesManager()
    
    var client: PostgrestClient {
        Client.shared.client.database
    }
    
    func getAllNotes(userId: UUID) async throws -> [Note] {
        let notes: [Note] = try await client
            .from("notes")
            .select()
            .eq("userId", value: userId)
            .order("dateCreated", ascending: false)
            .execute()
            .value
        return notes
    }
    
    func updateNote(note: Note) async throws -> Note {
        return try await client
            .from("notes")
            .upsert(note, returning: .representation)
            .single()
            .execute()
            .value
    }
    
    func createNote(note: Note) async throws -> Note {        
        return try await client
            .from("notes")
            .insert(note, returning: .representation)
            .single()
            .execute()
            .value
    }
    
    func deleteNote(noteId: Int) async throws {
        try await client
            .from("notes")
            .delete()
            .eq("noteId", value: noteId)
            .execute()
    }
    
}
