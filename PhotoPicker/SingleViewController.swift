//
//  SingleViewController.swift
//  
//
//  Created by 相澤 隆志 on 2015/04/05.
//
//

import UIKit
import Photos

class SingleViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UIScrollViewDelegate{
    var imageData:UIImage!
    var currentIndex:NSIndexPath!
    var images:[AnyObject] = []
    private var imageManager:ImageManager!
    private var flickrManager:FlickrManager!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageManager = ImageManager.sharedInstance
        flickrManager = FlickrManager.sharedInstance
        self.collectionView.reloadData()
        let index:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        //self.collectionView.scrollToItemAtIndexPath(currentIndex, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        let offsetX:CGFloat = self.collectionView.bounds.width * CGFloat(currentIndex.row)
        let offset:CGPoint = CGPointMake(offsetX, 0)
        self.collectionView.setContentOffset(offset, animated: false)
        self.collectionView.reloadData()
        let current:Int = currentIndex.row
        println("index:\(current)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        
        var count:Int
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            if imageManager.isSelectMode == true {
                count = imageManager.getImageCount(currentIndex.section)
            }else{
                count = imageManager.allImageCount
            }
        }else{
            count = flickrManager.countOfImages
        }
        return count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SingleCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SIngleViewCell", forIndexPath: indexPath) as SingleCollectionViewCell
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as AppDelegate
        if appdelegate.getSourceType() == SourceType.iOSDevice {
            var asset:PHAsset
            if imageManager.isSelectMode == true {
                asset = imageManager.getAsset(indexPath.section, index: indexPath.row) as PHAsset
            }else{
                asset = imageManager.getAsset(indexPath.row) as PHAsset
            }
            let width:CGFloat = CGFloat(asset.pixelWidth)
            let height:CGFloat = CGFloat(asset.pixelHeight)
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(width, height), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                cell.imageView.image = image
            })

        }else{
            flickrManager.getImage(indexPath, targetImage: &(cell.imageView!), size: SizeOfGetImage.Middle)
        }
        let offset:CGPoint = CGPointMake(CGFloat(collectionView.bounds.width) * CGFloat(currentIndex.row),0)
        self.collectionView.setContentOffset(offset,animated:false)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width:CGFloat = self.collectionView.bounds.width
        let height:CGFloat = self.collectionView.bounds.height
        return CGSizeMake(width, height)
    }

    func scrollViewDidEndDecelerating( scrollview:UIScrollView ) {
        println("Scroll: offset")
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
