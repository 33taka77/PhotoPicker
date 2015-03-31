//
//  CrossBaweCollectionViewCell.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/31.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit
import Photos

class CrossBaweCollectionViewCell: UICollectionViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    var imageArray:[PHAsset] = []
    var imageManager:ImageManager!
    var thumbSize:ThumbnailSize = ThumbnailSize.Large
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setup() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        imageManager = ImageManager.sharedInstance
        self.collectionView.reloadData()
    }
    
    func setThumbnailSize( size:ThumbnailSize ) {
        thumbSize = size
        self.collectionView.reloadData()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CrossThumbnailCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CrossThumbnailCell", forIndexPath: indexPath) as CrossThumbnailCollectionViewCell
        let asset:PHAsset = imageArray[indexPath.row]
        //let asset: PHAsset? = info["object"] as? PHAsset
        //et imgWidth:CGFloat = info["pixelWidth"] as CGFloat
        //let imgHeight:CGFloat = info["pixelHeight"] as CGFloat
        
        let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
        let imgHeight = CGFloat(asset.pixelHeight)
        let sizeX:CGFloat =  CGFloat(asset.pixelWidth/2)
        let sizeY:CGFloat = CGFloat(asset.pixelHeight/2)
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(sizeX, sizeY), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.imageView.image = image
        })
        //let imgData:UIImage = imageManager.GetImageData(imageArray[indexPath.row], size: CGSizeMake(imgWidth,imgHeight) )
        //cell.imageView.image = imgData
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let info:PHAsset = imageArray[indexPath.row] as PHAsset
        let imgWidth:CGFloat = CGFloat(info.pixelWidth)
        let imgHeight:CGFloat = CGFloat(info.pixelHeight)
        //let width:CGFloat = imgWidth/imgHeight * constHeightOfSlideCell
        var width:CGFloat
        var height:CGFloat
        switch thumbSize {
        case ThumbnailSize.Large:
            width = self.collectionView.frame.width - 10
            height = constHeightOfSlideCellLarge
        case ThumbnailSize.Middle:
            width = constHeightOfSlideCellMiddle
            height = constHeightOfSlideCellMiddle
        case ThumbnailSize.Small:
            width = constHeightOfSlideCellSmall*imgHeight/imgWidth
            height = constHeightOfSlideCellSmall
        default:
            println("Unknown Size")
        }
        return CGSizeMake(width, height)
    }
    
}
