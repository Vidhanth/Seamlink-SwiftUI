//
//  YoutubeData.swift
//  Seamlink
//
//  Created by Vidhanth on 21/12/23.
//

import Foundation

struct YoutubeData: Codable {
    let id: String
    let title: String
    let channelName: String
    let thumbURL: String
    let channelThumbURL: String
    let duration: String
    let progress: Double?
    
    init(id: String, title: String, channelName: String, thumbURL: String, channelThumbURL: String, duration: String, progress: Double? = nil) {
        self.id = id
        self.title = title
        self.channelName = channelName
        self.thumbURL = thumbURL
        self.channelThumbURL = channelThumbURL
        self.duration = duration
        self.progress = progress
    }
    
}
