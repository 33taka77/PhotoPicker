//
//  CenterThumbnailViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/30.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit
import Photos

enum SourceType {
    case iOSDevice
    case Flickr
}

class CenterThumbnailViewController: UIViewController,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UIScrollViewDelegate {
    
    private var imageManager:ImageManager!
    private var collectionLayout:CHTCollectionViewWaterfallLayout!
    private var cellSizes:[CGSize] = []
    private var selectModeFlag:Bool = false
    private var selectedItemArray:[Int] = []
    private var flickrManager:FlickrManager!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var selectModeButton: UIBarButtonItem!
    @IBAction func pushuSelectModeChange(sender: AnyObject) {
        if imageManager.isSelectMode  == true {
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
    
    @IBAction func selectedSource(sender: AnyObject) {
        let segment:UISegmentedControl! = sender as! UISegmentedControl
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        
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
        collectionView.reloadData()
    }
    
    @IBOutlet weak var sourceSelector: UISegmentedControl!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var eraseButton: UIBarButtonItem!
    func pushShareButton() {
        
        var selectedImageArray:[UIImage] = []
        
        for var i = 0; i < imageManager.getCountOfSelectedItemsIndex(); i++ {
            //let index = imageManager.getSelectedItem(i)
            let index = imageManager.getSelectedItemIndex(i)
            let item:PHAsset = imageManager.getAsset(index.row) as! PHAsset
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
    
    var columnCount:Int {
        get{
            return collectionLayout.columnCount
        }
        set(value){
            collectionLayout.columnCount = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "写真閲覧"
        let iconHome:UIImage = UIImage(named: "Home-51.png")!
        let leftButton:UIBarButtonItem = UIBarButtonItem(image: iconHome, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPushed")
        self.navigationItem.leftBarButtonItem = leftButton

        let iconDraw:UIImage = UIImage(named: "icon_menu.png")!
        let rightButton:UIBarButtonItem = UIBarButtonItem(image: iconDraw, style: UIBarButtonItemStyle.Plain, target: self, action: "drawerButtonPushed")
        self.navigationItem.rightBarButtonItem = rightButton

        flickrManager = FlickrManager.sharedInstance
        flickrManager.fetchInterestingnessPhotos(updateFlickr)
        imageManager = ImageManager.sharedInstance
        imageManager.collectAssets { () -> Void in
            self.collectionView.reloadData()
        }
        if imageManager.isSelectMode == true {
            self.navigationItem.title = "写真選択モード"
            showToolBarButtons()
        }else{
            self.navigationItem.title = "写真閲覧"
            clearAllSellect()
        }
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate

        if appdelegate.getSourceType() == SourceType.iOSDevice {
            sourceSelector.selectedSegmentIndex = 0
            selectModeButton.enabled = true
        }else{
            sourceSelector.selectedSegmentIndex = 1
            selectModeButton.enabled = false
        }
    }
    func updateFlickr() {
        
    }
    
    func showToolBarButtons() {
        let item:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "1428027456_common_share_action-128-3.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "pushShareButton")
        item.width = 80
        toolBar.items?.append(item)
        let item2:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_trash_alt.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "")
        item2.width = 80
        toolBar.items?.append(item2)
        
    }
    func hideToolBarButtons() {
        toolBar.items?.removeAtIndex(2)
        toolBar.items?.removeAtIndex(1)
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
        self.collectionView.reloadData()
     }
    func backButtonPushed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func drawerButtonPushed() {
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        appdelegate.openCloseDrawer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSize() {
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            for var i = 0; i < imageManager.allImageCount; i++ {
                //let size:CGSize = CGSizeMake(arc4random() % 50+50, arc4random() % 50+50)
                let width:CGFloat = CGFloat(arc4random() % 50+50)
                let asset:PHAsset = imageManager.getAsset(i) as! PHAsset
                let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
                let imgHeight:CGFloat = CGFloat(asset.pixelHeight)
                
                let height:CGFloat = width*imgHeight/imgWidth
                let size:CGSize = CGSizeMake(width, height)
                cellSizes.append(size)
            }
        }else{
            for var i = 0; i < flickrManager.countOfImages; i++ {
                let width:CGFloat = CGFloat(arc4random() % 50+50)
                let index:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
                let imgSize:CGSize = flickrManager.getSizeOfImage(index)
                let height:CGFloat = width*imgSize.height/imgSize.width
                let size:CGSize = CGSizeMake(width, height)
                cellSizes.append(size)
            }
        }
        /*
        for var i = 0; i < imageManager.allImageCount; i++ {
            //let size:CGSize = CGSizeMake(arc4random() % 50+50, arc4random() % 50+50)
            let width:CGFloat = CGFloat(arc4random() % 50+50)
            let asset:PHAsset = imageManager.getAsset(i) as PHAsset
            let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
            let imgHeight:CGFloat = CGFloat(asset.pixelHeight)
            
            let height:CGFloat = width*imgHeight/imgWidth
            let size:CGSize = CGSizeMake(width, height)
            cellSizes.append(size)
        }
        */
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        var count:Int
        setupSize()
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            count = imageManager.allImageCount
        }else{
            count = flickrManager.countOfImages
        }
 
        return count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ThumbnailWaterFallCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailWaterFallCell", forIndexPath: indexPath) as! ThumbnailWaterFallCollectionViewCell
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            let asset:PHAsset = imageManager.getAsset(indexPath.row) as! PHAsset
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(250, 250), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                cell.thumbnailImageView.image = image
                //if self.imageManager.isSelected(indexPath.row) == false {
                if self.imageManager.isSelected(indexPath) == false {
                    cell.checkButton.hidden = true
                }else{
                    cell.checkButton.hidden = false
                }
            })
        }else{
            flickrManager.getImage(indexPath, targetImage: &(cell.thumbnailImageView!), size: SizeOfGetImage.Small)
            if self.imageManager.isSelected(indexPath) == false {
                cell.checkButton.hidden = true
            }else{
                cell.checkButton.hidden = false
            }
        }
/*
        let asset:PHAsset = imageManager.getAsset(indexPath.row) as PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(250, 250), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.thumbnailImageView.image = image
            //if self.imageManager.isSelected(indexPath.row) == false {
            if self.imageManager.isSelected(indexPath) == false {
                cell.checkButton.hidden = true
            }else{
                cell.checkButton.hidden = false
            }
        })
        
        if indexPath.row == 0 {
            println("Debug")
        }
*/
       return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let temp:CHTCollectionViewWaterfallLayout? = collectionViewLayout as? CHTCollectionViewWaterfallLayout
        if temp != nil {
            collectionLayout = temp
        }else{
            println("nil error")
        }
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        var size:CGSize
        //if appdelegate.getSourceType() == SourceType.iOSDevice {
            size = cellSizes[indexPath.item]
        //}else{
        //    size = flickrManager.getSizeOfImage(indexPath)
        //}
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.imageManager.isSelectMode == true {
            
            let cell:ThumbnailWaterFallCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! ThumbnailWaterFallCollectionViewCell
            //if imageManager.isSelected(indexPath.row) == false {
            if imageManager.isSelected(indexPath) == false {
                //cell.selectedStatus = false
                cell.checkButton.hidden = false
                imageManager.appendSelectedItemIndex(indexPath)
            }else{
                //cell.selectedStatus = true
                cell.checkButton.hidden = true
                imageManager.removeSelectedItemIndex(indexPath)
            }
        }else{
            
            let viewController:SingleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SingleViewController") as! SingleViewController
            let application:UIApplication = UIApplication.sharedApplication()
            let appdelegate:AppDelegate = application.delegate as! AppDelegate
            if appdelegate.getSourceType() == SourceType.iOSDevice {
                let index:Int = indexPath.row
                let section:Int = indexPath.section
                viewController.currentIndex = indexPath
            }else{
                viewController.currentIndex = indexPath
            }
            self.navigationController?.pushViewController(viewController, animated: true)

            //singleViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            //self.presentViewController(singleViewController, animated: true, completion: nil)
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let rect:CGRect = scrollView.bounds
        println("scroll:originX=\(rect.origin.x) originY=\(rect.origin.y)")
        println("scroll:width=\(rect.width) height=\(rect.height)")
        println("scroll:sizeWidth=\(rect.size.width) sizeHeight=\(rect.size.height)")

    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.sourceSelector.alpha = 1.0
        })
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.sourceSelector.alpha = 0.0
        })
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
