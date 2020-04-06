//
//  YoutubeVc.swift
//  CareTogether
//
//  Created by HeinHtet on 06/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import YouTubePlayer
import JGProgressHUD
class YoutubeVc: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var lyYoutubeFrame: YouTubePlayerView!
    var videoId : String?
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyYoutubeFrame.isHidden = true
        hud.textLabel.text = "လုပ်ဆောင်ပါသည်"
        hud.show(in: self.view)
        lyYoutubeFrame.loadVideoID(videoId ?? "")
        lyYoutubeFrame.play()
        lyYoutubeFrame.delegate = self
    }
    


}

extension YoutubeVc : YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        lyYoutubeFrame.isHidden = false
        hud.dismiss(animated: true)
    }
    
    
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
    
    }
    
    
}
