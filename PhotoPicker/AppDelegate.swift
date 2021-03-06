//
//  AppDelegate.swift
//  PhotoPicker
//
//  Created by 相澤 隆志 on 2015/03/29.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import UIKit
import CoreData

enum CenterViewControllerType{
    case waterFallThumbnail
    case clossCollectionThumbnai
    case listThumbnail
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MSDynamicsDrawerViewControllerDelegate {

    var window: UIWindow?
    var dynamicsDrawerViewController:MSDynamicsDrawerViewController!
    var centerViewControllerBk:CenterThumbnailViewController!
    var centerControllerDictionary:[CenterViewControllerType:AnyObject] = [:]
    var sourceType:SourceType = SourceType.iOSDevice
    
    func setupDrawer(viewController:UIViewController) {
        self.dynamicsDrawerViewController = viewController as! MSDynamicsDrawerViewController
        self.dynamicsDrawerViewController.delegate = self
        let styleArray:[AnyObject] = [MSDynamicsDrawerScaleStyler.styler(),MSDynamicsDrawerFadeStyler.styler(),MSDynamicsDrawerShadowStyler.styler()]
        self.dynamicsDrawerViewController.addStylersFromArray(styleArray, forDirection: MSDynamicsDrawerDirection.Right)
        //let centerViewController:CenterThumbnailViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("CenterThumbnailViewController") as CenterThumbnailViewController
        let rightViewController:RightOptionSettingViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("RightOptionSettingViewController") as! RightOptionSettingViewController
        self.dynamicsDrawerViewController.setDrawerViewController(rightViewController, forDirection: MSDynamicsDrawerDirection.Right)
        setCenterViewController(CenterViewControllerType.waterFallThumbnail)
        /*
        let paneNavigationContorller:UINavigationController = UINavigationController(rootViewController: centerViewController)
        self.dynamicsDrawerViewController.setPaneViewController(paneNavigationContorller, animated: false, completion: nil)
        centerControllerDictionary[CenterViewControllerType.waterFallThumbnail] = centerViewController
        centerViewControllerBk = centerViewController
        */
    }
    
    func openCloseDrawer() {
        self.dynamicsDrawerViewController.setPaneState(MSDynamicsDrawerPaneState.Open, inDirection:MSDynamicsDrawerDirection.Right, animated:true, allowUserInterruption:true, completion:nil);
    }
    
    func changeCrossThumbSize( size:ThumbnailSize ) {
        let centerViewController:CrossThumbnailViewController = centerControllerDictionary[CenterViewControllerType.clossCollectionThumbnai] as! CrossThumbnailViewController
        centerViewController.setThumbnailSize(size)
    }
    
    func changeWaterFallColumnCount( count:Int ) {
        let centerViewController:CenterThumbnailViewController = centerControllerDictionary[CenterViewControllerType.waterFallThumbnail] as! CenterThumbnailViewController
        centerViewController.columnCount = count
    }
    
    func setCenterViewController(type:CenterViewControllerType) {
        var centerViewController: UIViewController!
        
        switch type {
        case CenterViewControllerType.waterFallThumbnail:
            if centerControllerDictionary[CenterViewControllerType.waterFallThumbnail] == nil {
                centerControllerDictionary[CenterViewControllerType.waterFallThumbnail] = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("CenterThumbnailViewController") as! CenterThumbnailViewController
            }
            centerViewController = centerControllerDictionary[CenterViewControllerType.waterFallThumbnail] as! UIViewController
        case CenterViewControllerType.clossCollectionThumbnai:
            if centerControllerDictionary[CenterViewControllerType.clossCollectionThumbnai] == nil {
                centerControllerDictionary[CenterViewControllerType.clossCollectionThumbnai] = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("CrossThumbnailView") as! CrossThumbnailViewController
            }
            centerViewController = centerControllerDictionary[CenterViewControllerType.clossCollectionThumbnai] as! UIViewController
        default:
            println("Unknown Type")
        }
        let paneNavigationContorller:UINavigationController = UINavigationController(rootViewController: centerViewController)
        self.dynamicsDrawerViewController.setPaneViewController(paneNavigationContorller, animated: false, completion: nil)
        
    }
    
    func setSourceType(type:SourceType) {
        sourceType = type
    }
    func getSourceType()->SourceType {
        return sourceType
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "net.takashi.aizawa.PhotoPicker" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("PhotoPicker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PhotoPicker.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

