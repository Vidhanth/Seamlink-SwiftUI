//
//  NewNoteViewModel.swift
//  Seamlink
//
//  Created by Vidhanth on 26/12/23.
//

import SwiftUI

@MainActor class NewNoteViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var autoTitle: Bool = false
    @Published var isLoading: Bool = false
    
    var userId: UUID? = nil
    
    var availableLinks: [URL] {
        text.extractURLs()
    }
    
    func setInitialValuesFromNote(note: Note?) {
        guard let note else { return }
        title = note.title ?? ""
        text = note.text
    }
    
    func saveNote() async -> Result {
        isLoading = true
        do {
            let note: Note = try await getNote()
            let newNote = try await NotesManager.shared.createNote(note: note)
            isLoading = false
            return Result(success: true, payload: newNote)
        } catch {
            print(error)
            isLoading = false
            return Result(success: false, payload: error)
        }
    }
    
    func updateNote(oldValue oldNote: Note) async -> Result {
        isLoading = true
        do {
            let note: Note = try await getNote(oldValue: oldNote)
            let updatedNote = try await NotesManager.shared.updateNote(note: note)
            isLoading = false
            return Result(success: true, payload: updatedNote)
        } catch {
            print(error)
            isLoading = false
            return Result(success: false, payload: error)
        }
    }
    
    func getNote(oldValue oldNote: Note? = nil) async throws -> Note {
        
        guard let userId else {
            throw SmError.notLoggedIn
        }
        
        if (text.isEmpty) {
            throw SmError.noteEmpty
        }
        
        let id = oldNote?.noteId
        let dateCreated = oldNote?.dateCreated ?? Date()
        
        if (availableLinks.isEmpty || !autoTitle) {
            let note = Note(userId: userId, noteId: id, text: text.trim(), title: title.trim(), dateCreated: dateCreated, dateUpdated: Date(), tags: "", type: .note)
            return note
        }
        
        let url: URL = availableLinks.first!
        
        if (url.absoluteString.isYoutubeLink) {
            
            do {
                let youtubeData = try await YoutubeParser.shared.getVideoDetails(url: url.absoluteString)
                return Note(userId: userId, noteId: id, text: text.trim(), title: youtubeData.title, dateCreated: dateCreated, dateUpdated: Date(), tags: "", type: .youtube, channelName: youtubeData.channelName, thumbURL: youtubeData.thumbURL, channelThumbURL: youtubeData.channelThumbURL, duration: youtubeData.duration, progress: youtubeData.progress)
            } catch {
                let urlTitle = UrlParser.shared.getTitle(from: url)
                return Note(userId: userId, noteId: id, text: text.trim(), title: urlTitle.isEmpty ? title : urlTitle, dateCreated: dateCreated, dateUpdated: Date(), tags: "", type: .link)
            }
            
        }
        
        let urlTitle = UrlParser.shared.getTitle(from: url)
        return Note(userId: userId, noteId: id, text: text.trim(), title: urlTitle.isEmpty ? title : urlTitle, dateCreated: dateCreated, dateUpdated: Date(), tags: "", type: .link)
        
    }
    
}
