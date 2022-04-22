//
//  PlayButton.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/21/22.
//

import SwiftUI
import AVFoundation

struct PlayButtonView: View {
    @State var  isPlaying: Bool = false
    @State var player = AVPlayer()
    var file: String?
    
    var body: some View {
        Button(action: {
            guard let url = URL(string: file ?? "") else { return }
            print(url)
            do {
                player = try AVPlayer(playerItem: AVPlayerItem(url: url))
                player.play()
            } catch {
                print("error")
            }
        }) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 50))

        }
    
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonView(file: "")
    }
}
