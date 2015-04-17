//
//  RightOptionSettingViewController.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/30.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit

class RightOptionSettingViewController: UIViewController {

    @IBOutlet weak var columnCont: UILabel!
    @IBOutlet weak var steper: UIStepper!
    
    @IBOutlet weak var dispModeSegment: UISegmentedControl!
    @IBAction func changeDispMode(sender: AnyObject) {
        let segment:UISegmentedControl! = sender as! UISegmentedControl
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate

        switch segment.selectedSegmentIndex {
        case 0:
            appdelegate.setCenterViewController(CenterViewControllerType.waterFallThumbnail)
            selectorForThumbSize.enabled = false
            steper.enabled = true
        case 1:
            appdelegate.setCenterViewController(CenterViewControllerType.clossCollectionThumbnai)
            selectorForThumbSize.enabled = true
            steper.enabled = false
        default:
            println("Unknown segment")
        }
    }
    
    @IBOutlet weak var selectorForThumbSize: UISegmentedControl!
    
    @IBAction func selectedSize(sender: AnyObject) {
        let segment:UISegmentedControl! = sender as! UISegmentedControl
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        
        switch segment.selectedSegmentIndex {
        case 0:
            appdelegate.changeCrossThumbSize(ThumbnailSize.Large)
        case 1:
            appdelegate.changeCrossThumbSize(ThumbnailSize.Middle)
        case 2:
            appdelegate.changeCrossThumbSize(ThumbnailSize.Small)
        default:
            println("Unknown segment")
        }
    }
    
    @IBAction func changeStep(sender: AnyObject) {
        let c:Double = self.steper.value
        columnCont.text = convertDoubleToString(c)
        let application:UIApplication = UIApplication.sharedApplication()
        let appdelegate:AppDelegate = application.delegate as! AppDelegate
        appdelegate.changeWaterFallColumnCount(Int(c))
    }
    
    func convertDoubleToString( d:Double )->String {
        let intNum:Int = Int(d)
        let countString:String = String(intNum)
        return countString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.steper.value = 3
        self.steper.minimumValue = 2
        self.steper.maximumValue = 5
        self.steper.stepValue = 1
        self.columnCont.text = convertDoubleToString(self.steper.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
