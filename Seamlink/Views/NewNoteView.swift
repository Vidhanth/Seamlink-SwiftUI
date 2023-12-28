//
//  NewNoteView.swift
//  Seamlink
//
//  Created by Vidhanth on 24/12/23.
//

import SwiftUI


enum FocusedTextField {
    case titleField
    case textField
}

struct NewNoteView: View {
    
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var viewModel = NewNoteViewModel()
    @Binding var isPresented: Bool
    @Binding var addedNote: Note?
    @Binding var updatedNote: Note?
    @FocusState var focusedField: FocusedTextField?
    
    var body: some View {
        
        NavigationStack {
            VStack {
                VStack {
                    TextField("Title", text: $viewModel.title)
                        .focused($focusedField, equals: .titleField)
                        .padding(.top, 5)
                        .padding(.horizontal, 8)
                        .font(.title2)
                        .fontWeight(.bold)
                        .submitLabel(.next)
                        .background(.gray.opacity(0.0))
                        .onSubmit {
                            focusedField = .textField
                        }
                    TextEditor(text: $viewModel.text)
                        .focused($focusedField, equals: .textField)
                        .padding(.bottom)
                        .padding(.horizontal, 5)
                        .textEditorStyle(.plain)
                        .submitLabel(.done)
                        .onChange(of: viewModel.text, {
                            viewModel.autoTitle = !viewModel.availableLinks.isEmpty
                        })
                        .onSubmit {
                            focusedField = nil
                        }
                        .background(.gray.opacity(0.0))
                }
                .padding(10)
                .background(.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 15))
                Toggle(isOn: $viewModel.autoTitle) {
                    VStack (alignment: .leading) {
                        Text("Automatically get link details")
                        Text("This will override your current title text.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(viewModel.availableLinks.isEmpty ? 0.5 : 1)
                }.disabled(viewModel.availableLinks.isEmpty)
                    .padding(5)
                    .padding(.bottom, 5)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            if (updatedNote == nil) {
                                let result = await viewModel.saveNote()
                                if (result.success) {
                                    addedNote = (result.payload as! Note)
                                    isPresented = false
                                } else {
                                    if (result.payload as! SmError == SmError.noteEmpty) {
                                        isPresented = false
                                    }
                                }
                                return
                            }
                            let result = await viewModel.updateNote(oldValue: updatedNote!)
                            if (result.success) {
                                updatedNote = (result.payload as! Note)
                                isPresented = false
                            } else {
                                if (result.payload as! SmError == SmError.noteEmpty) {
                                    isPresented = false
                                }
                            }
                        }
                    } label: {
                        if (viewModel.isLoading) {
                            HStack {
                                Text ("__")
                                    .foregroundStyle(.background)
                                ProgressView()
                                    .tint(.accentColor)
                                Text ("__")
                                    .foregroundStyle(.background)
                            }
                        } else {
                            Text ("Done")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text ("Cancel")
                    }
                }
            }
            .onAppear {
                viewModel.userId = currentSession.user?.id
                viewModel.setInitialValuesFromNote(note: updatedNote)
                focusedField = .textField
            }
            .safeAreaPadding(.horizontal)
        }
    }
}

#Preview {
    NewNoteView(isPresented: .constant(true), addedNote: .constant(MockData.dummyNote), updatedNote: .constant(nil))
}
