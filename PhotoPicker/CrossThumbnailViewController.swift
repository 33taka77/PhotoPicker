//
//  CrossThumbnailViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/31.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit
import Photos

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
    var flickrManager:FlickrManager!
    
    var thumbSize:ThumbnailSize = ThumbnailSize.Large
    var thumbnailCell:CrossBaweCollectionViewCell!
    
    @IBOutlet weak var sourceSELECTOR: UISegmentedControl!
    @IBAction func selectedSource(sender: AnyObject) {
        let segment:UISegmentedControl! = sender as UISegmentedControl
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        
        switch segment.selectedSegmentIndex {
        case 0:
            appdelegate.setSourceType(SourceType.iOSDevice)
            selectModeButton.enabled = true
        case 1:
            appdelegate.setSourceType(SourceType.Flickr)
            selectModeButton.enabled = false
        default:
            println("Unknown segment")
        }
        baseCollectionView.reloadData()
    }
    @IBOutlet weak var tooBar: UIToolbar!
    @IBOutlet weak var selectModeButton: UIBarButtonItem!
    @IBAction func pushShareButton(sender: AnyObject) {
        if imageManager.isSelectMode == true {
            self.navigationItem.title = "写真閲覧"
            selectModeButton.image = UIImage(named: "icon_box-checked.png")
            imageManager.isSelectMode = false
            hideToolBarButtons()
            clearAllSellect()
        }else{
            imageManager.isSelectMode = true
            self.navigationItem.title = "写真選択モード"
            selectModeButton.image = UIImage(named: "Activity Grid 2-32.png")
            showToolBarButtons()
        }
    }
    
    @IBOutlet weak var baseCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let iconHome:UIImage = UIImage(named: "Home-51.png")!
        let leftButton:UIBarButtonItem = UIBarButtonItem(image: iconHome, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPushed")
        self.navigationItem.leftBarButtonItem = leftButton
        
        let iconDraw:UIImage = UIImage(named: "icon_menu.png")!
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: iconDraw, style: UIBarButtonItemStyle.Plain, target: self, action: "drawerButtonPushed")
        self.navigationItem.rightBarButtonItem = rightButton

        imageManager = ImageManager.sharedInstance
        flickrManager = FlickrManager.sharedInstance
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        //if appdelegate.getSourceType() == SourceType.iOSDevice {
            imageManager.sortByKeyOfAssetDate()
        //}
        if imageManager.isSelectMode == true {
            self.navigationItem.title = "写真選択モード"
            showToolBarButtons()
        }else{
            self.navigationItem.title = "写真閲覧"
            clearAllSellect()
        }
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            sourceSELECTOR.selectedSegmentIndex = 0
            selectModeButton.enabled = true
        }else{
            sourceSELECTOR.selectedSegmentIndex = 1
            selectModeButton.enabled = false
        }
    }
    func showToolBarButtons() {
        let item:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "1428027456_common_share_action-128-3.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "pushShareButton")
        item.width = 80
        tooBar.items?.append(item)
        let item2:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_trash_alt.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "")
        item2.width = 80
        tooBar.items?.append(item2)
        
    }
    func hideToolBarButtons() {
        tooBar.items?.removeAtIndex(2)
        tooBar.items?.removeAtIndex(1)
    }
    func clearAllSellect() {
        for var i = 0; i < imageManager.getCountOfSelectedItems(); i++ {
            /*
            let index:NSIndexPath = NSIndexPath(forItem:imageManager.getSelectedItem(i), inSection: 0)
            let cell:ThumbnailWaterFallCollectionViewCell = self.collectionView.cellForItemAtIndexPath(index) as ThumbnailWaterFallCollectionViewCell
            
            cell.checkButton.hidden = true
            cell.selectedStatus = false
            */
        }
        imageManager.removeAllSelectedItemIndex()
        self.baseCollectionView.reloadData()
    }
    func pushShareButton() {
        var selectedImageArray:[UIImage] = []
        for var i = 0; i < imageManager.getCountOfSelectedItemsIndex(); i++ {
            //let index = imageManager.getSelectedItem(i)
            let index = imageManager.getSelectedItemIndex(i)
            let item:PHAsset = imageManager.getAsset(index.section, index: index.row) as PHAsset
            let width:CGFloat = CGFloat(item.pixelWidth)
            let height:CGFloat = CGFloat(item.pixelHeight)
            PHImageManager.defaultManager().requestImageForAsset(item, targetSize: CGSizeMake(width, height), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                let img:UIImage = image
                selectedImageArray.append(img)
            })
        }
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: selectedImageArray, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
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
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        var count:Int
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            count = imageManager.sectionCount
        }else{
            count = 1
        }
        return count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CrossBaweCollectionViewCell = self.baseCollectionView.dequeueReusableCellWithReuseIdentifier("BaseCollectionViewCell", forIndexPath: indexPath) as CrossBaweCollectionViewCell
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            cell.imageArray = imageManager.getImageArray(imageManager.getSectionName(indexPath.section))
            cell.setup()
            cell.setThumbnailSize(thumbSize)
            thumbnailCell = cell
        }else{
            cell.setup()
            cell.setThumbnailSize(thumbSize)
            thumbnailCell = cell
        }
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
            let application:UIApplication = UIApplication.sharedApplication()
            let appdelegate:AppDelegate = application.delegate as AppDelegate
            if appdelegate.getSourceType() == SourceType.iOSDevice {
                header?.sectionTitle.text = imageManager.getSectionName(indexPath.section)
            }else{
                header?.sectionTitle.text = "flickr"
            }
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
