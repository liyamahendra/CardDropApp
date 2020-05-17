//
//  OverviewCollectionViewController.swift
//  CardDropApp
//
//  Created by Brian Advent on 21.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class OverviewCollectionViewController: UICollectionViewController {

    let yogaPoseDataRequest = DataRequest<YogaPose>(dataSource: "YogaPoses")
    var yogaPoseData = [YogaPose]()
    
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        yogaPoseDataRequest.getData{ [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not load categories")
            case .success(let cateogires):
                self?.yogaPoseData = cateogires
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let yogaPose = sender as! YogaPose
            guard let image = UIImage(named: yogaPose.categoryImageName) else {return}
            
            let imageSelectionVC = segue.destination as! ImageSelectionViewController
            imageSelectionVC.image = image
            imageSelectionVC.yogaPose = yogaPose
        }
    }
    

}

// MARK: - CollectionView DataSource
extension OverviewCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yogaPoseData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCollectionViewCell else {fatalError("Could not create proper cateogry cell for collection view")}
        
        let category = yogaPoseData[indexPath.item]
        
        guard let image = UIImage(named: category.categoryImageName) else {fatalError("Could not load image for cell")}
        
        cell.backgroundImageView.image = image
        cell.categoryLabel.text = category.categoryName
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension OverviewCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 14
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = yogaPoseData[indexPath.item]
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: category)
        
    }
}

// MARK: - CollectionView Layout Delegate
extension OverviewCollectionViewController : UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let height = view.frame.size.height
        let width = view.frame.size.width
        return CGSize(width: width * 0.5 - 40, height: 225)
    }
    
}

// MARK: - Transitioning Animation Delegate
extension OverviewCollectionViewController : Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else {return nil}
            
            return cell.backgroundImageView
        }
        
        return nil
    }
}
