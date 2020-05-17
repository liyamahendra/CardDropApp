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

    var image:UIImage?
    var yogaPose:YogaPose?
    
    //let imageDataRequest = DataRequest<Pose>(dataSource: "Images")
    var imageData = [Pose]()
    
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
        
        if let availableImage = image, let availableCategory = yogaPose {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
        imageData = (yogaPose?.poses)! as [Pose]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loadData()
        setupUI()
    }
    
    
//    func loadData() {
//        imageDataRequest.getData{ [weak self] dataResult in
//            switch dataResult {
//            case .failure:
//                print("Could not load images")
//            case .success(let images):
//                self?.imageData = images
//                DispatchQueue.main.async {
//                    self?.setupUI()
//                }
//            }
//
//        }
//    }
    
    func setupUI() {
        
        UIView.animate(withDuration: 0.5) {
            self.initialDimView.alpha = 1
            self.backButton.alpha = 1
        }
        
        scrollView.delegate = self
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(imageData.count + 1)
        
        for (i, image) in imageData.enumerated() {
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else {return}
            
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image.imageName)!
            
            photoView.descriptionLabel.text = image.description
            photoView.photographerLabel.text = image.photographer
            
            scrollView.addSubview(photoView)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSelectionViewController.didPressOnScrollView(recognizer:)))
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc
    func didPressOnScrollView (recognizer:UITapGestureRecognizer) {
        if currentScrollViewPage != 0 {
            //self.performSegue(withIdentifier: "showCard", sender: self)
            playVideo()
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
            guard let imageToSend = UIImage(named: imageData[currentScrollViewPage - 1].imageName) else {return}
            
            sendCardVC.backgroundImage = imageToSend
            sendCardVC.modalTransitionStyle = .crossDissolve
        }
    }
    
    func playVideo() {
        var mediaPath = imageData[currentScrollViewPage - 1].mediaPath
        let isLocal = imageData[currentScrollViewPage - 1].isLocal
        
        if isLocal {
            mediaPath = Bundle.main.path(forResource: mediaPath, ofType:"mp4")! // FIXME: Hard coding extension
        }
        
        let mediaURL = (isLocal) ? URL(fileURLWithPath: mediaPath) : URL(string: mediaPath)
        let player = AVPlayer(url: mediaURL!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        UIApplication.shared.keyWindow?.rootViewController?.present(playerController, animated: true, completion: {
            player.play()
        })
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
