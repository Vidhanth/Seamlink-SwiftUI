//
//  OptionsSheet.swift
//  Seamlink
//
//  Created by Vidhanth on 27/12/23.
//

import SwiftUI

struct OptionsSheet: View {
    
    @ObservedObject var viewModel: NoteListViewModel
    let note: Note
    
    
    
    var body: some View {
        
        Form {
            Section() {
                NoteItemView(note: note, showBackground: false)
            }
            .padding(0)
            Section {
                if (note.type != .note) {
                    OptionButton(label: "Open and Delete", systemImage: "link.circle") {
                        viewModel.noteToOpenDelete = note
                        viewModel.isOptionsSheetPresented = false
                    }
                }
                OptionButton(label: "Edit", systemImage: "pencil.circle") {
                    viewModel.updatedNote = note
                    viewModel.isOptionsSheetPresented = false
                }
                OptionButton(label: "Delete", systemImage: "xmark.circle", onTap: {
                    viewModel.noteToDelete = note
                    viewModel.isOptionsSheetPresented = false
                })
                    .tint(.red)                
            }.padding(5)
            Section {
                ShareLink(item: note.getShareableText()) {
                    HStack{
                        Text("Share")
                        Spacer()
                        Image(systemName: "square.and.arrow.up.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .padding(1)
                }
            }.padding(5)
            Section {
                HStack {
                    Spacer()
                    Button {
                        viewModel.isOptionsSheetPresented = false
                    } label: {
                        Text("Cancel")
                    }.tint(.red)
                    Spacer()
                }
            }.padding(8)
        }.listSectionSpacing(20)
        
    }
}

struct OptionButton: View {
    
    let label: String
    let systemImage: String
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack{
                Text(label)
                Spacer()
                Image(systemName: systemImage)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
        .padding(1)
    }
    
}

#Preview {
    OptionsSheet(viewModel: NoteListViewModel(), note: MockData.dummyNote)
}
