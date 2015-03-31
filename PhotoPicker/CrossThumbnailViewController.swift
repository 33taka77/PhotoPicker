//
//  CrossThumbnailViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/31.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit


let constHeightOfSlideCell:CGFloat = 240.0

class CrossThumbnailViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {

    var imageManager:ImageManager!

    
    @IBOutlet weak var baseCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageManager = ImageManager.sharedInstance
        imageManager.sortByKeyOfAssetDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInCollectionView(collectionView:UICollectionView)->NSInteger{
        let count = imageManager.sectionCount
        return count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CrossBaweCollectionViewCell = self.baseCollectionView.dequeueReusableCellWithReuseIdentifier("SideSlideCell", forIndexPath: indexPath) as CrossBaweCollectionViewCell
        cell.imageArray = imageManager.getImageArray(imageManager.getSectionName(indexPath.section))
        cell.setup()
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width:CGFloat = self.baseCollectionView.bounds.width
        let height:CGFloat = constHeightOfSlideCell
        return CGSizeMake(width, height)
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header : CrossBaesHeaderCollectionReusableView? = nil
        if (kind == UICollectionElementKindSectionHeader) {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CrossBaseHeader", forIndexPath: indexPath)
                as? CrossBaesHeaderCollectionReusableView
            header?.sectionTitle.text = imageManager.getSectionName(indexPath.section)
        }
        return header!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
