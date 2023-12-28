//
//  RemoteImage.swift
//  Seamlink
//
//  Created by Vidhanth on 21/12/23.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURLString urlString: String) {
        NetworkManager.shared.downloadImage(fromURLString: urlString) { uiImage in
            guard let uiImage else {
                return
            }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}

struct RemoteImage: View {
        
    @State var isLoaded: Bool = false
    var image: Image?
    
    var body: some View {
        if image == nil {
            Image(systemName: "video")
                .tint(Color(UIColor.systemBackground))
        } else {
            VStack {
                if isLoaded {
                    image!
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isLoaded)
            .onAppear {
                if (!self.isLoaded) {
                    self.isLoaded.toggle()
                }
            }
        }
    }
}

struct AppRemoteImage: View {

    @StateObject var imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear {
                imageLoader.load(fromURLString: urlString)
            }
            .onChange(of: urlString) { oldValue, newValue in
                imageLoader.load(fromURLString: newValue)
            }
    }
    
}



#Preview {
    AppRemoteImage(urlString: "https://i.ytimg.com/vi/Xwa5YAjRu2M/hqdefault.jpg")
}
