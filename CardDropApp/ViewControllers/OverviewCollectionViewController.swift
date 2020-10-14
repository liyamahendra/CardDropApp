//
//  OverviewCollectionViewController.swift
//  CardDropApp
//
//  Created by Brian Advent on 21.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import ProgressHUD

class OverviewCollectionViewController: UICollectionViewController {

    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        ProgressHUD.show()
        if let request = RequestModel.getAllCategories.constructURLRequest() {
            APIClient.sharedInstance.performRequest(request: request, canCancelRequest: false, completion: { (response) in
                ProgressHUD.dismiss()
                do {
                    let data = try JSONSerialization.data(withJSONObject: response.resultObj!, options: .prettyPrinted)
                    DataStore.categories = try JSONDecoder().decode(Category.self, from: data)
                    self.collectionView.reloadData()
                } catch {
                    print("Error while decoding the categories response.")
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let categoryPose = sender as! CategoryData
            let imageSelectionVC = segue.destination as! ImageSelectionViewController
            imageSelectionVC.categoryData = categoryPose
        }
    }
    

}

// MARK: - CollectionView DataSource
extension OverviewCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataStore.categories?.data?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCollectionViewCell else {fatalError("Could not create proper cateogry cell for collection view")}

        let categoryData = DataStore.categories?.data?[indexPath.row]
        cell.backgroundImageView.imageURL(categoryData?.imageURL ?? "")
        cell.categoryLabel.text = categoryData?.name
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension OverviewCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 14
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryData = DataStore.categories?.data?[indexPath.item]
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: categoryData)
        
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
