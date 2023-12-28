//
//  NetworkManager.swift
//  Seamlink
//
//  Created by Vidhanth on 21/12/23.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    
    private init() {}
    
    func getDataFromApi(url: String) async throws -> [String: Any] {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "HTTP Error", code: 0, userInfo: nil)
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return jsonObject ?? [:]
        } catch {
            throw NSError(domain: "JSON Parsing Error", code: 0, userInfo: [NSUnderlyingErrorKey: error])
        }
    }
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
        
    }
    
}
