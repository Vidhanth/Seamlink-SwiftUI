//
//  TagPicker.swift
//  Seamlink
//
//  Created by Vidhanth on 07/01/24.
//

import SwiftUI

struct TagPicker: View {
    
    @Binding var selectedIndices: [Int]
    @EnvironmentObject var currentSession: CurrentSession
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<currentSession.tags.count, id: \.self) { index in
                    TagItem(tagLabel: currentSession.tags[index], isSelected: selectedIndices.contains(index))
                        .onTapGesture {
                            if (selectedIndices.contains(index)) {
                                selectedIndices.removeAll { selectedIndex in
                                    selectedIndex == index
                                }
                            } else {
                                selectedIndices.append(index)
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.top, 8)
    }
}

#Preview {
    TagPicker(selectedIndices: .constant([1]))
}
