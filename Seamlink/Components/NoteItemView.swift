//
//  LinkTile.swift
//  Seamlink
//
//  Created by Vidhanth on 14/11/23.
//

import SwiftUI

struct NoteItemView: View {
    
    let note: Note
    var showBackground: Bool = true
    var tags: [String]
    
    var body: some View {
        VStack (alignment: .leading){
            Group {
                if (note.type == .youtube)
                {
                    HStack (alignment: .center) {
                        ZStack (alignment: .bottomTrailing) {
                            AppRemoteImage(urlString: note.thumbURL!)
                                .frame(width: 160, height: 90)
                                .background(.gray.opacity(0.3))
                                .clipShape(.rect(cornerRadius: 10))
                            Text(note.duration!)
                                .font(.system(size: 10))
                                .padding(5)
                                .background(Color(UIColor.systemBackground).opacity(0.7))
                                .clipShape(.rect(cornerRadius: 5))
                                .padding([.trailing], 5)
                        }
                        VStack (alignment: .leading, spacing: 0) {
                            
                            Text(note.title!)
                                .fontWeight(.bold)
                                .lineLimit(3)
                            
                            Text(note.channelName!)
                                .padding([.top], 5)
                        }
                    }
                }
                else {
                    VStack (alignment: .leading) {
                        if (!(note.title ?? "").isEmpty) {
                            Text(note.title!)
                                .fontWeight(.bold)
                        }
                        Text(note.text)
                    }
                }
            }
            if (!note.tags.isEmpty) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(note.tags, id: \.self) { tag in
                            TagItem(tagLabel: tags[tag])
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(showBackground ? 10 : 0)
        .background(.gray.opacity(showBackground ? 0.2 : 0.0))
        .clipShape(.rect(cornerRadius: showBackground ? 10 : 0))
    }
}

#Preview {
    NoteItemView(note: MockData.dummyNote, showBackground: false, tags: ["Prod", "Pers"])
}
