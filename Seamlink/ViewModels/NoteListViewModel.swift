//
//  NoteListViewModel.swift
//  Seamlink
//
//  Created by Vidhanth on 26/12/23.
//

import SwiftUI

@MainActor class NoteListViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var isLoading: Bool = true
    @Published var isSearchPresented: Bool = false
    @Published var isDeleteConfirmPresented: Bool = false
    @Published var isOpenDeleteConfirmPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isOptionsSheetPresented: Bool = false
    @Published var notes: [Note] = []

    var addedNote: Note? = nil
    var updatedNote: Note? = nil
    var noteToDelete: Note? = nil
    var noteToOpenDelete: Note? = nil
    var selectedNote: Note? = nil
    
    func handleOptionsClosed() {
        if noteToDelete != nil {
            isDeleteConfirmPresented = true
        }
        if noteToOpenDelete != nil {
            isOpenDeleteConfirmPresented = true
        }
        if updatedNote != nil {
            isSheetPresented = true
        }
        selectedNote = nil
    }

    func addNote(note: Note) {
        withAnimation {
            notes.append(note)
            notes.sort(by: { $0.dateCreated > $1.dateCreated })
        }
    }
    
    func updateNote(note: Note) {
        withAnimation {
            if let index = notes.firstIndex(where: { $0.noteId == note.noteId }) {
                notes[index] = note
            }
        }
    }

    func updateNotes() {
        if let addedNote = addedNote {
            addNote(note: addedNote)
        }
        if let updatedNote = updatedNote {
            updateNote(note: updatedNote)
        }
        addedNote = nil
        updatedNote = nil
    }
    
    func deleteNote(note: Note) async {
        do {
            withAnimation {
                notes.removeAll { n in
                    n.noteId == note.noteId
                }
            }
            try await NotesManager.shared.deleteNote(noteId: note.noteId!)
        } catch {
            print(error)
            addNote(note: note)
        }
    }

    func checkAndDeleteNote() {
        Task {
            if let noteToDelete {
               await deleteNote(note: noteToDelete)
            }
            if let noteToOpenDelete {
               await deleteNote(note: noteToOpenDelete)
            }
            noteToDelete = nil
            noteToOpenDelete = nil
        }
    }

    func getNotes(userId: UUID?) {

        guard let userId else {
            notes = []
            return
        }

        Task {
            isLoading = notes.isEmpty
            do {
                let newNotes = try await NotesManager.shared.getAllNotes(userId: userId)
                withAnimation {
                    notes = newNotes
                }
            } catch {
                print(error)
                notes = []
            }
            isLoading = false
            addedNote = nil
        }

    }

}
