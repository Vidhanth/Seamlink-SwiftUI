//
//  TagItem.swift
//  Seamlink
//
//  Created by Vidhanth on 20/12/23.
//

import SwiftUI

struct TagItem: View {
        
    let tagLabel: String;
    
    var body: some View {
        Text(tagLabel)
            .font(.system(size: 12))
            .padding(5)
            .background(Color(UIColor.label).opacity(0.2))
            .clipShape(.rect(cornerRadius: 5))
    }
}

#Preview {
    TagItem(tagLabel: "Hello")
}
