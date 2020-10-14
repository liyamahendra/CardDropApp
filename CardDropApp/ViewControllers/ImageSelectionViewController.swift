//
//  ImageSelectionViewController.swift
//  CardDropApp
//
//  Created by Brian Advent on 22.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ImageSelectionViewController: UIViewController {
    
    var categoryData:CategoryData?
    var allPoses = [Pose]()

    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var initialDimView: UIView!
    @IBOutlet weak var categoryDescription: UILabel!
    
    var currentScrollViewPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDimView.alpha = 0
        backButton.alpha = 0
        
        initialImageView.imageURL(categoryData?.imageURL ?? "")
        categoryLabel.text = categoryData?.name
        
        allPoses = (categoryData?.poses)! as [Pose]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loadData()
        setupUI()
    }
    
    func setupUI() {
        
        UIView.animate(withDuration: 0.5) {
            self.initialDimView.alpha = 1
            self.backButton.alpha = 1
        }
        
        scrollView.delegate = self
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(allPoses.count + 1)
        
        for (i, pose) in allPoses.enumerated() {
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else {return}
            
            photoView.frame = frame
            photoView.imageView.imageURL(pose.imageURL ?? "")
            
            photoView.descriptionLabel.text = pose.description
            photoView.photographerLabel.text = pose.photographer
            
            scrollView.addSubview(photoView)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSelectionViewController.didPressOnScrollView(recognizer:)))
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc
    func didPressOnScrollView (recognizer:UITapGestureRecognizer) {
        if currentScrollViewPage != 0 {
            self.performSegue(withIdentifier: "showPoseDetails", sender: self)
            //playVideo()
        }else{
            scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
            currentScrollViewPage = 1
        }
        
    }
    

    @IBAction func goBack(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.initialDimView.alpha = 0
                sender.alpha = 0
            }, completion: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            guard let sendCardVC = segue.destination as? SendCardViewController else {return}
            //guard let imageToSend = UIImage(named: poses[currentScrollViewPage - 1].imageName) else {return}
            var imageToSend: UIImage?
            let url = URL(string: allPoses[currentScrollViewPage - 1].imageURL ?? "")

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    imageToSend = UIImage(data: data!)
                }
            }
            
            sendCardVC.backgroundImage = imageToSend
            sendCardVC.modalTransitionStyle = .crossDissolve
        } else if segue.identifier == "showPoseDetails" {
            guard let poseDetailsVC = segue.destination as? PoseDetailsViewController else {return}
            poseDetailsVC.selectedPose = allPoses[currentScrollViewPage - 1]
            poseDetailsVC.modalTransitionStyle = .crossDissolve
        }
    }
    
    func playVideo() {
        if allPoses.count > 0, let videoURL = allPoses[currentScrollViewPage - 1].videoURL {
            let mediaURL = URL(string: videoURL)!
            let player = AVPlayer(url: mediaURL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            UIApplication.shared.keyWindow?.rootViewController?.present(playerController, animated: true, completion: {
                player.play()
            })
        }
    }
    
}

extension ImageSelectionViewController : Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
}

extension ImageSelectionViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentScrollViewPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
