//
//  TagItem.swift
//  Seamlink
//
//  Created by Vidhanth on 20/12/23.
//

import SwiftUI

struct TagItem: View {
        
    let tagLabel: String;
    let isSelected: Bool
    
    init(tagLabel: String, isSelected: Bool = false) {
        self.tagLabel = tagLabel
        self.isSelected = isSelected
    }
    
    var body: some View {
        Text(tagLabel)
            .font(.system(size: 12))
            .foregroundStyle(Color(isSelected ? UIColor.systemBackground : UIColor.label))
            .padding(5)
            .background(Color(UIColor.label).opacity(isSelected ? 0.8 : 0.2))
            .clipShape(.rect(cornerRadius: 5))
    }
}

#Preview {
    TagItem(tagLabel: "Hello")
}
