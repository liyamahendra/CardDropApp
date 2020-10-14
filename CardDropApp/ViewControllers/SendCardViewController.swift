//
//  SendCardViewController.swift
//  CardDropApp
//
//  Created by Brian Advent on 02.09.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import ProgressHUD

class SendCardViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var backgroundImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = backgroundImage else {return}
        backgroundImageView.image = image
        
        loadData()
        
    }
    
    func loadData() {
        if let request = RequestModel.getAllCategories.constructURLRequest() {
            APIClient.sharedInstance.performRequest(request: request, canCancelRequest: false, completion: { (response) in
                ProgressHUD.dismiss()
                print("Response: ", response)
            })
        }
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareCard(_ sender: UIButton) {
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = true})
        let image = self.view.screenshot()
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = false})
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true)
        
    }
    
}


extension UIView {
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
}
