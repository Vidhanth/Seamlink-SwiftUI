//
//  Note.swift
//  Seamlink
//
//  Created by Vidhanth on 21/12/23.
//

import Foundation

enum NoteType: Int, Codable {
    case note
    case youtube
    case link
}

struct Note: Codable {
    
    let noteId: Int?
    let userId: UUID
    let text: String
    let title: String?
    let dateCreated: Date
    let dateUpdated: Date
    let tags: [Int]
    let type: NoteType
    // Youtube Data
    let channelName: String?
    let thumbURL: String?
    let channelThumbURL: String?
    let duration: String?
    let progress: Double?
    
    init(userId: UUID, noteId: Int? = nil, text: String, title: String? = nil, dateCreated: Date, dateUpdated: Date, tags: [Int] = [], type: NoteType, channelName: String? = nil, thumbURL: String? = nil, channelThumbURL: String? = nil, duration: String? = nil, progress: Double? = nil) {
        self.userId = userId
        self.noteId = noteId
        self.text = text
        self.title = title
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.tags = tags
        self.type = type
        self.channelName = channelName
        self.thumbURL = thumbURL
        self.channelThumbURL = channelThumbURL
        self.duration = duration
        self.progress = progress
    }
    
}

extension Note {
    
    func getShareableText() -> String {
        
        if (type != .note || (title ?? "").isEmpty) {
            return text
        }
        
        return "\(title ?? "")\n\(text)"
        
    }
    
    func contains(searchText: String, userTags: [String]) -> Bool {
        let lowerCasedSearchText = searchText.lowercased()
        if (text.lowercased().contains(lowerCasedSearchText)) {
            return true
        }
        if ((title ?? "").lowercased().contains(lowerCasedSearchText)) {
            return true
        }
        if ((channelName ?? "").lowercased().contains(lowerCasedSearchText)) {
            return true
        }
        if ((duration ?? "").lowercased().contains(lowerCasedSearchText)) {
            return true
        }
        for tag in tags {
            if (userTags[tag].lowercased().contains(lowerCasedSearchText)) {
                return true
            }
        }
        return false
    }
    
}

struct MockData {
    static let dummyNote = Note(userId: UUID(), text: "youtube.com", title: "for evrery inta dslkfjlaksdjfl kjasdflj lkjsd evrery inta dslkfjlaksdjfl kjasdflj lkjsd", dateCreated: Date(), dateUpdated: Date(), tags: [0], type: .youtube, channelName: "TechSource", thumbURL: "https://i.ytimg.com/vi/Xwa5YAjRu2M/hqdefault.jpg", duration: "10:20")
}
