//
//  ThumbnailWaterFallCollectionViewCell.swift
//  PhotoPicker
//
//  Created by Aizawa Takashi on 2015/03/30.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit

class ThumbnailWaterFallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    private var isSelected:Bool = false
    
    var selectedStatus:Bool {
        get{
            return isSelected
        }
        set(flag){
            isSelected = flag
        }
    }
}
