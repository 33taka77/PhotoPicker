//
//  FlickrMngr.swift
//  PhotoPicker
//
//  Created by 相澤 隆志 on 2015/04/04.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import Foundation

enum SizeOfGetImage {
    case Large
    case Middle
    case Small
}

class FlickrManager {
    var imageArray:[Dictionary<String,Any>] = []
    class var sharedInstance:FlickrManager {
        struct Static{
            static let instance:FlickrManager = FlickrManager()
        }
        return Static.instance
    }
    
    var countOfImages:Int {
        get{
            return imageArray.count
        }
    }
    
    func fetchInterestingnessPhotos(update: ()->Void) {
        let flickrMangr:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let url :String = "https://api.flickr.com/services/rest/"
        var parameters :Dictionary = [
            "method"         : "flickr.interestingness.getList",
            //"method"         : "flickr.photos.search",
            "api_key"        : "685147fe878a39bf9b9853ae77b31e0b",
            "per_page"       : "99",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_m,url_l,url_o",
        ]
        let requestSuccess = {
            (operation:AFHTTPRequestOperation!, responseObject:AnyObject?) -> Void in
            let dict:NSDictionary = responseObject as NSDictionary
            let key: NSString = NSString(string: "photos")
            let imgs:NSDictionary? = dict.objectForKey(key) as? NSDictionary
            let subKey:NSString = NSString(string: "photo")
            let array:[NSDictionary] = imgs!.objectForKey(subKey) as [NSDictionary]
            for info in array {
                var dict:Dictionary<String,Any> = [:]
                dict["object"] = info
                let photoId:String? = info["id"] as? String
                func getSize( size:CGSize ){
                    dict["size"] = size
                    imageArray.append(dict)
                    update()
                }
                self.fetchImageSize(photoId!, returnSize: getSize )
            }
        }
        let requestFailure = {
            (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
            NSLog("requestFailure: \(error)")
        }
        flickrMangr.GET(url, parameters: parameters, success: requestSuccess, failure: requestFailure)
    }
    func fetchImageSize( id:String, returnSize:(CGSize)->Void ){
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let url :String = "https://api.flickr.com/services/rest/"
        var parameters :Dictionary = [
            //"method"         : "flickr.interestingness.getList",
            "method"         : "flickr.photos.getSizes",
            "api_key"        : "685147fe878a39bf9b9853ae77b31e0b",
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
        //let photoId:String? = item["id"] as? String
        parameters["photo_id"] = id
        
        let requestSuccess = {
            (operation:AFHTTPRequestOperation!, responseObject:AnyObject?) -> Void in
            let dict:NSDictionary = responseObject as NSDictionary
            let key: NSString = NSString(string: "sizes")
            let sizes:NSDictionary? = dict.objectForKey(key) as? NSDictionary
            let subKey:NSString = NSString(string: "size")
            let array:[NSDictionary] = sizes!.objectForKey(subKey) as [NSDictionary]
            var width:CGFloat = 0
            var height:CGFloat = 0

            for element:NSDictionary in array {
                if element["label"] as String == "Medium" {
                    var widthSrt: NSString = element["width"] as NSString
                    var heightStr: NSString = element["height"] as NSString
                    println("image size: width = \(width) height = \(height)")
                    width = CGFloat(widthSrt.floatValue)
                    height = CGFloat(heightStr.floatValue)
                    break
                }
            }
            let sizeOfImage:CGSize = CGSizeMake(width, height)
            returnSize(sizeOfImage)
        }
        
        let requestFailure = {
            (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
            NSLog("requestFailure: \(error)")
        }
        manager.GET(url, parameters: parameters, success: requestSuccess, failure: requestFailure)

    }
    func getSizeOfImage(index:NSIndexPath)->CGSize {
        let item:[String:Any] = imageArray[index.row]
        let size:CGSize = item["size"] as CGSize
        return size
    }
    func getImage(index:NSIndexPath, inout targetImage:UIImageView, size:SizeOfGetImage) {
        let info = self.imageArray[index.row] as Dictionary
        let item:NSDictionary = info["object"] as NSDictionary
        var photoUrlString:String
        switch size {
        case SizeOfGetImage.Large:
            photoUrlString = item["url_o"] as String
        case SizeOfGetImage.Middle:
            photoUrlString = item["url_l"] as String
        case SizeOfGetImage.Small:
            photoUrlString = item["url_m"] as String
        default:
            println("error")
        }
        let url : NSURL = NSURL(string: photoUrlString)!
        let request : NSURLRequest = NSURLRequest(URL: NSURL(string: photoUrlString)!)
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            let size: CGSize = image.size
            let x:CGFloat = size.width
            let y:CGFloat = size.height
            
            print("Real size: width = \(x)")
            println("Real size: height = \(y)")
            
            targetImage.image = image;
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        targetImage.setImageWithURLRequest(request, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)

    }
}
