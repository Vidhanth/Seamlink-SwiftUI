//
//  YoutubeParser.swift
//  Seamlink
//
//  Created by Vidhanth on 24/12/23.
//

import Foundation

class YoutubeParser {
    
    static let shared: YoutubeParser = YoutubeParser()
    
    let demoUrl = "https://youtu.be/detVm5_74NU?si=wselqibyeMh-GA-K&t=4m6s"
    let demoPlaylistUrl = "https://youtube.com/playlist?list=PLWLedd0Zw3c4uSUjspp45KjWMHd6rZHem"
    
    func getVideoDetails(url: String) async throws -> YoutubeData {
        
        
        
        let id = getVideoID(from: url)
        let apiUrl: String = url.contains("playlist")
        ? "https://www.googleapis.com/youtube/v3/playlists?id=\(id)&key=AIzaSyDOAca4V6Nll2OcJKVDl7n74VN5n_SzbrI&part=snippet&part=contentDetails&fields=items(snippet(title,channelTitle,channelId,thumbnails(maxres/url,high/url)),contentDetails/itemCount)"
        : "https://www.googleapis.com/youtube/v3/videos?id=\(id)&key=AIzaSyDOAca4V6Nll2OcJKVDl7n74VN5n_SzbrI&part=snippet&part=contentDetails&fields=items(snippet(title,channelTitle,channelId,thumbnails(maxres/url,high/url)),contentDetails/duration)"
        
        do {
            let result = try await NetworkManager.shared.getDataFromApi(url: apiUrl)
            let youtubeData = parseYoutubeData(url: url, jsonResponse: result)            
            return youtubeData!
        } catch {
            throw error
        }
    }
    
//    func getChannelDetails(id: String) async {
//        let apiUrl: String = "https://www.googleapis.com/youtube/v3/channels?id=\(id)&key=AIzaSyDOAca4V6Nll2OcJKVDl7n74VN5n_SzbrI&part=snippet&fields=items(snippet(thumbnails(default/url)))"
//        do {
//            let result = try await NetworkManager.shared.getDataFromApi(url: apiUrl)
//        } catch {
//            print(error)
//        }
//    }
    
    private func parseYoutubeData(url:String, jsonResponse: [String: Any]) -> YoutubeData? {
        guard let items = jsonResponse["items"] as? [[String: Any]], let item = items.first else {
            return nil
        }
        
        guard let snippet = item["snippet"] as? [String: Any],
              let title = snippet["title"] as? String,
              let channelTitle = snippet["channelTitle"] as? String,
              let thumbnails = snippet["thumbnails"] as? [String: Any],
              let highThumbnail = thumbnails["high"] as? [String: String],
              let maxresThumbnail = thumbnails["maxres"] as? [String: String],
              let thumbnailURLString = highThumbnail["url"] ?? maxresThumbnail["url"] else {
            return nil
        }
        
        guard let contentDetails = item["contentDetails"] as? [String: Any],
              let duration = contentDetails["duration"] as? String else {
            return nil
        }
        
        let progress = getProgress(url, totalDurationString: parseDuration(duration))
        
        return YoutubeData(id: getVideoID(from: url), title: title, channelName: channelTitle, thumbURL: thumbnailURLString, channelThumbURL: "", duration: parseDuration(duration), progress: progress)
    }
    
    private func getVideoID(from url: String) -> String {
        if url.contains("playlist") {
            return url.components(separatedBy: "list=").last ?? ""
        }
        
        let pattern = #"http(?:s)?:\/\/(?:m.)?(?:w{3}\.)?youtu(?:\.be\/|be\.com\/(?:(?:shorts\/)|(?:watch\?(?:feature=youtu.be\&)?v=|v\/|embed\/|user\/(?:[\w#]+\/)+)))([^&#?\n]+)"#
        let exp = try? NSRegularExpression(pattern: pattern, options: [])
        guard let matches = exp?.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count)),
              let match = matches.first else {
            return ""
        }
        
        let range = Range(match.range(at: 1), in: url)
        return range.map { String(url[$0]) } ?? ""
    }
    
    private func parseDuration(_ rawDuration: String) -> String {
        var duration = [0, 0, 0]
        let pattern = "PT(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+)S)?"
        let exp = try? NSRegularExpression(pattern: pattern, options: [])
        guard let matches = exp?.matches(in: rawDuration, options: [], range: NSRange(location: 0, length: rawDuration.utf16.count)),
              let match = matches.first else {
            return "00:00:00"
        }
        
        for i in 0..<duration.count {
            let range = Range(match.range(at: i + 1), in: rawDuration)
            duration[i] = Int(range.map { String(rawDuration[$0]) } ?? "0") ?? 0
        }
        
        let formattedDuration: String
        if duration[0] > 0 {
            formattedDuration = String(format: "%02d:%02d:%02d", duration[0], duration[1], duration[2])
        } else {
            formattedDuration = String(format: "%02d:%02d", duration[1], duration[2])
        }
        
        return formattedDuration
    }
    
    private func getProgress(_ url: String, totalDurationString: String) -> Double? {
        guard let timestamp = URLComponents(string: url)?.queryItems?.first(where: { $0.name == "t" })?.value else {
            return nil
        }
        
        var progress: Double?
        let pattern = #"[msh]?\d*[msh]?"#
        let exp = try? NSRegularExpression(pattern: pattern, options: [])
        let matches = exp?.matches(in: timestamp, options: [], range: NSRange(location: 0, length: timestamp.utf16.count)) ?? []
        var seconds = 0
        
        for match in matches {
            let segmentRange = Range(match.range, in: timestamp)!
            let segment = String(timestamp[segmentRange])
            
            if segment.contains("m") {
                seconds += (Int(segment.replacingOccurrences(of: "m", with: "")) ?? 0) * 60
            } else if segment.contains("h") {
                seconds += (Int(segment.replacingOccurrences(of: "h", with: "")) ?? 0) * 60 * 60
            } else {
                if !segment.isEmpty {
                    seconds += Int(segment.replacingOccurrences(of: "s", with: "")) ?? 0
                }
            }
        }
        
        // Convert total duration string to seconds
        let totalDurationComponents = totalDurationString.components(separatedBy: ":")
        var totalSeconds = 0
        
        if totalDurationComponents.count >= 3 {
            if let hours = Int(totalDurationComponents[0]), let minutes = Int(totalDurationComponents[1]), let seconds = Int(totalDurationComponents[2]) {
                totalSeconds = hours * 3600 + minutes * 60 + seconds
            }
        } else if totalDurationComponents.count == 2 {
            if let minutes = Int(totalDurationComponents[0]), let seconds = Int(totalDurationComponents[1]) {
                totalSeconds = minutes * 60 + seconds
            }
        }
        
        if totalSeconds >= seconds {
            progress = Double(seconds) / Double(totalSeconds)
        }
        
        return progress
    }
    
}
