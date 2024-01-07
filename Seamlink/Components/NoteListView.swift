//
//  NoteListView.swift
//  Seamlink
//
//  Created by Vidhanth on 21/12/23.
//

import SwiftUI

struct NoteListView: View {
    
    @StateObject var viewModel = NoteListViewModel()
    @EnvironmentObject var currentSession: CurrentSession
    
    var body: some View {
        NavigationStack {
            Group{
                if (viewModel.isLoading) {
                    ProgressView()
                        .tint(.accent)
                } else {
                    if (viewModel.notes.isEmpty) {
                        VStack {
                            Image(systemName: "note.text")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                                .frame(width: 100)
                                .padding()
                            Text("No Notes")
                                .font(.title2)
                                .foregroundStyle(.gray)
                            Text("Create a new note to see it here.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    } else {
                        List {
                            ForEach (viewModel.notes, id: \.noteId!) { note in
                                if (note.contains(searchText: viewModel.searchText, userTags: currentSession.tags ) || !viewModel.isSearchPresented) {
                                    NoteItemView(note: note, tags: currentSession.tags)
                                        .listRowSeparator(.hidden)
                                        .onTapGesture {
                                            if (note.type != .note) {
                                                UIApplication.shared.open(note.text.extractURLs().first!)
                                            } else {
                                                viewModel.updatedNote = note
                                                viewModel.isSheetPresented = true
                                            }
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button("Delete", systemImage: "trash") {
                                                viewModel.noteToDelete = note
                                                viewModel.isDeleteConfirmPresented = true
                                            }.tint(.red)
                                            Button("More", systemImage: "ellipsis") {
                                                viewModel.selectedNote = note
                                                viewModel.isOptionsSheetPresented = true
                                            }.tint(.gray)
                                        }
                                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                            Button("Edit", systemImage: "pencil") {
                                                viewModel.updatedNote = note
                                                viewModel.isSheetPresented = true
                                            }.tint(.blue)
                                            Button("Copy", systemImage: "doc.on.doc") {
                                                UIPasteboard.general.string = note.getShareableText()
                                            }.tint(.gray)
                                        }
                                }
                            }
                            .listRowInsets(.init(top: 5, leading: 15, bottom: 5, trailing: 15))
                        }
                        .listStyle(.plain)
                        .refreshable{
                            viewModel.getNotes(userId: currentSession.user?.id)
                        }
                        .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearchPresented)
                    }
                }
            }.navigationTitle("My Notes")
                .confirmationDialog("deleteConfirm", isPresented: $viewModel.isDeleteConfirmPresented) {
                    Button("Delete", role: .destructive) {
                        viewModel.checkAndDeleteNote()
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.noteToDelete = nil
                    }
                } message: {
                    Text("Delete this note? You cannot undo this action")
                }.confirmationDialog("openDeleteConfirm", isPresented: $viewModel.isOpenDeleteConfirmPresented) {
                    Button("Open and Delete", role: .destructive) {
                        UIApplication.shared.open(viewModel.noteToOpenDelete!.text.extractURLs().first!)
                        viewModel.checkAndDeleteNote()
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.noteToOpenDelete = nil
                    }
                } message: {
                    Text("Open and delete this note? You cannot undo this action")
                }
                .sheet(isPresented: $viewModel.isSheetPresented, onDismiss: {
                    viewModel.updateNotes()
                }) {
                    NewNoteView(isPresented: $viewModel.isSheetPresented, addedNote: $viewModel.addedNote, updatedNote: $viewModel.updatedNote)
                }
                .sheet(isPresented: $viewModel.isOptionsSheetPresented, onDismiss: {
                    viewModel.handleOptionsClosed()
                }) {
                    OptionsSheet(viewModel: viewModel, note: viewModel.selectedNote!)
                        .presentationDetents([.fraction(0.45), .medium, .large])
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            viewModel.isSheetPresented = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                            Text("New Note")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Image("Icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(.rect(cornerRadius: 7))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundStyle(.accent)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .task {
                    viewModel.getNotes(userId: currentSession.user?.id)
                }
        }
    }
}

//#Preview {
//    NoteListView()
//}
