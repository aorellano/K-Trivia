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
    @State var systemImage: String?
    
    
    var body: some View {
        Button(action: {
            playPause()

        }) {
            Image(systemName: systemImage ?? "")
                .font(.system(size: 50))

        }.onAppear {
            playPause()
        }
    
    }
    
    func playPause() {
        self.isPlaying.toggle()
       
        guard let url = URL(string: file ?? "") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }catch {
                //error handeling here
        }
        player = AVPlayer(playerItem: AVPlayerItem(url: url))
        player.play()
        systemImage = "playpause.fill"
    }
}



struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonView(file: "")
    }
}
