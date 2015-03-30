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

    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var columnCount:Int {
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
        imageManager = ImageManager.sharedInstance
        
        imageManager.collectAssets { () -> Void in
            self.collectionView.reloadData()
        }
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
        let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
        let imgHeight = CGFloat(asset.pixelHeight)
        let sizeX:CGFloat =  CGFloat(asset.pixelWidth/4)
        let sizeY:CGFloat = CGFloat(asset.pixelHeight/4)
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(sizeX, sizeY), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.thumbnailImageView.image = image
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        collectionLayout = collectionViewLayout as CHTCollectionViewWaterfallLayout
        let size:CGSize = cellSizes[indexPath.item]
        return size
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
