//
//  CenterThumbnailViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/30.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit
import Photos

class CenterThumbnailViewController: UIViewController,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource {
    
    private var imageManager:ImageManager!
    private var collectionLayout:CHTCollectionViewWaterfallLayout!
    private var cellSizes:[CGSize] = []
    private var selectModeFlag:Bool = false
    private var selectedItemArray:[Int] = []
    
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
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var eraseButton: UIBarButtonItem!
    func pushShareButton() {
        var selectedImageArray:[UIImage] = []
        for var i = 0; i < imageManager.getCountOfSelectedItemsIndex(); i++ {
            //let index = imageManager.getSelectedItem(i)
            let index = imageManager.getSelectedItemIndex(i)
            let item:PHAsset = imageManager.getAsset(index.row) as PHAsset
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
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        appdelegate.openCloseDrawer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSize() {
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
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setupSize()
        return imageManager.allImageCount
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ThumbnailWaterFallCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailWaterFallCell", forIndexPath: indexPath) as ThumbnailWaterFallCollectionViewCell
        
        let asset:PHAsset = imageManager.getAsset(indexPath.row) as PHAsset
        /*
        let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
        let imgHeight = CGFloat(asset.pixelHeight)
        let sizeX:CGFloat =  CGFloat(asset.pixelWidth/4)
        let sizeY:CGFloat = CGFloat(asset.pixelHeight/4)
        */
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
       return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let temp:CHTCollectionViewWaterfallLayout? = collectionViewLayout as? CHTCollectionViewWaterfallLayout
        if temp != nil {
            collectionLayout = temp
        }else{
            println("nil error")
        }
        let size:CGSize = cellSizes[indexPath.item]
        //let size:CGSize = CGSizeMake(120, 100)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.imageManager.isSelectMode == true {
            
            let cell:ThumbnailWaterFallCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as ThumbnailWaterFallCollectionViewCell
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
            
        }
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
