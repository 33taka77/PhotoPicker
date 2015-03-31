//
//  CrossThumbnailViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/31.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit

enum ThumbnailSize {
    case Large
    case Middle
    case Small
}

let constHeightOfSlideCellLarge:CGFloat = 240.0
let constHeightOfSlideCellMiddle:CGFloat = 180.0
let constHeightOfSlideCellSmall:CGFloat = 120.0

class CrossThumbnailViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {

    var imageManager:ImageManager!
    var thumbSize:ThumbnailSize = ThumbnailSize.Large
    var thumbnailCell:CrossBaweCollectionViewCell!
    
    
    @IBOutlet weak var baseCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let iconHome:UIImage = UIImage(named: "Home-51.png")!
        let leftButton:UIBarButtonItem = UIBarButtonItem(image: iconHome, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPushed")
        self.navigationItem.leftBarButtonItem = leftButton
        
        let iconDraw:UIImage = UIImage(named: "Activity Feed 2-51ー.png")!
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: iconDraw, style: UIBarButtonItemStyle.Plain, target: self, action: "drawerButtonPushed")
        self.navigationItem.rightBarButtonItem = rightButton

        imageManager = ImageManager.sharedInstance
        imageManager.sortByKeyOfAssetDate()
    }

    func setThumbnailSize( size:ThumbnailSize ) {
        thumbSize = size
        self.thumbnailCell.setThumbnailSize(size)
        self.baseCollectionView.reloadData()
    }
    func backButtonPushed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func drawerButtonPushed() {
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        appdelegate.openCloseDrawer()
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
        let cell:CrossBaweCollectionViewCell = self.baseCollectionView.dequeueReusableCellWithReuseIdentifier("BaseCollectionViewCell", forIndexPath: indexPath) as CrossBaweCollectionViewCell
        cell.imageArray = imageManager.getImageArray(imageManager.getSectionName(indexPath.section))
        cell.setup()
        cell.setThumbnailSize(thumbSize)
        thumbnailCell = cell
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width:CGFloat
        var height:CGFloat
        switch thumbSize {
        case ThumbnailSize.Large:
            width = self.baseCollectionView.bounds.width
            height = constHeightOfSlideCellLarge
        case ThumbnailSize.Middle:
            width = self.baseCollectionView.bounds.width
            height = constHeightOfSlideCellMiddle
        case ThumbnailSize.Small:
            width = self.baseCollectionView.bounds.width
            height = constHeightOfSlideCellSmall
        default:
            println("Unknown size")
        }
        return CGSizeMake(width, height)
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header : CrossBaesHeaderCollectionReusableView? = nil
        if (kind == UICollectionElementKindSectionHeader) {
            header = baseCollectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CrossBaseHeaderIdentify", forIndexPath: indexPath)
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
