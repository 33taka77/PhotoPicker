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
    var flickrManager:FlickrManager!
    
    var thumbSize:ThumbnailSize = ThumbnailSize.Large
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setup() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        imageManager = ImageManager.sharedInstance
        flickrManager = FlickrManager.sharedInstance
        
        let layout:MyCollectionFlowLayout = MyCollectionFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.reloadData()
    }
    
    func setThumbnailSize( size:ThumbnailSize ) {
        thumbSize = size
        if thumbSize != ThumbnailSize.Large {
            self.collectionView.pagingEnabled = false
        }else{
            self.collectionView.pagingEnabled = true
        }
        self.collectionView.reloadData()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            return imageArray.count
        }else{
            return flickrManager.countOfImages
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CrossThumbnailCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CrossThumbnailCell", forIndexPath: indexPath) as CrossThumbnailCollectionViewCell
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            let asset:PHAsset = imageArray[indexPath.row]
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(500, 500), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                cell.imageView.image = image
                if self.imageManager.isSelected(indexPath) == false {
                    cell.checkButton.hidden = true
                }else{
                    cell.checkButton.hidden = false
                }
                
            })
        }else{
            flickrManager.getImage(indexPath, targetImage: &(cell.imageView!), size: SizeOfGetImage.Small)
            if self.imageManager.isSelected(indexPath) == false {
                cell.checkButton.hidden = true
            }else{
                cell.checkButton.hidden = false
            }
        }
       /*
        let asset:PHAsset = imageArray[indexPath.row]
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(500, 500), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.imageView.image = image
            if self.imageManager.isSelected(indexPath) == false {
                cell.checkButton.hidden = true
            }else{
                cell.checkButton.hidden = false
            }

        })
        */
        //let imgData:UIImage = imageManager.GetImageData(imageArray[indexPath.row], size: CGSizeMake(imgWidth,imgHeight) )
        //cell.imageView.image = imgData
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let index:Int = indexPath.item
        if index >= imageArray.count {
            println("index error")
        }
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        var imgWidth:CGFloat
        var imgHeight:CGFloat
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            let info:PHAsset = imageArray[indexPath.item] as PHAsset
            imgWidth = CGFloat(info.pixelWidth)
            imgHeight = CGFloat(info.pixelHeight)
        }else{
            let size:CGSize = flickrManager.getSizeOfImage(indexPath)
            imgWidth = size.width
            imgHeight = size.height
        }
        //let width:CGFloat = imgWidth/imgHeight * constHeightOfSlideCell
        
        var width:CGFloat = constHeightOfSlideCellMiddle
        var height:CGFloat = constHeightOfSlideCellMiddle
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.imageManager.isSelectMode == true {
            
            let cell:CrossThumbnailCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as CrossThumbnailCollectionViewCell
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
}
