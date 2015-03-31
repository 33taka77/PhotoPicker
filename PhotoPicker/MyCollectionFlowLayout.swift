//
//  MyCollectionFlowLayout.swift
//  PhotoPicker
//
//  Created by 相澤 隆志 on 2015/03/31.
//  Copyright (c) 2015年 &#30456;&#28580; &#38534;&#24535;. All rights reserved.
//

import UIKit

class MyCollectionFlowLayout: UICollectionViewFlowLayout {
   
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let attributes:[UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect)! as [UICollectionViewLayoutAttributes]
        for attribute in attributes {
            var newRect:CGRect = attribute.bounds
            newRect.size.width += 10
            attribute.bounds = newRect
        }
        return attributes
    }
}
