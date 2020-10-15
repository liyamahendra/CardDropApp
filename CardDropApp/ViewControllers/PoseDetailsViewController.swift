//
//  PoseDetailsViewController.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 14/10/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PoseDetailsViewController: UIViewController {
    
    var selectedPose: Pose!
    @IBOutlet weak var lblPoseTitle: UILabel!
    @IBOutlet weak var lblPoseDetails: UITextView!
    
    override func viewDidLoad() {
        lblPoseTitle.text = selectedPose.name
        lblPoseDetails.text = selectedPose.description
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func playVideo(_ sender: Any) {
        if let videoURL = selectedPose.videoURL {
            let mediaURL = URL(string: videoURL)!
            let player = AVPlayer(url: mediaURL)
            let playerController = AVPlayerViewController()
            playerController.player = player

            present(playerController, animated: true) {
                player.play()
            }
        }
    }
    
}
