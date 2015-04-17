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
        let attributes:[UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect)! as! [UICollectionViewLayoutAttributes]
        for attribute in attributes {
            var newRect:CGRect = attribute.bounds
            newRect.size.width += 5
            attribute.bounds = newRect
        }
        return attributes
    }
    
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset:CGPoint, withScrollingVelocity velocity:CGPoint )->CGPoint {
    
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let horizontalOffset:CGFloat = proposedContentOffset.x + (self.collectionView?.bounds.size.width)! / 2.0
        let targetRect = CGRectMake(proposedContentOffset.x, 0, (self.collectionView?.bounds.size.width)!, (self.collectionView?.bounds.size.height)!)
        let array:[AnyObject] = super.layoutAttributesForElementsInRect(targetRect)!
        for layoutAttributes:UICollectionViewLayoutAttributes in array as! [UICollectionViewLayoutAttributes] {
            let itemOffset:CGFloat = layoutAttributes.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)

        /*
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter:CGFloat = proposedContentOffset.x + (self.collectionView?.bounds.size.width)! / 2.0

        let targetRect = CGRectMake(proposedContentOffset.x, 0, (self.collectionView?.bounds.size.width)!, (self.collectionView?.bounds.size.height)!)
        let array:[AnyObject] = super.layoutAttributesForElementsInRect(targetRect)!
        for layoutAttributes:UICollectionViewLayoutAttributes in array as [UICollectionViewLayoutAttributes] {
            if layoutAttributes.representedElementCategory != UICollectionElementCategory.Cell {
                continue
            }
            let itemHorizontalCenter:CGFloat = layoutAttributes.center.x
            offsetAdjustment = itemHorizontalCenter - horizontalCenter
            layoutAttributes.alpha = 0
            if velocity.x < 0 {
                break
            }
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)
        */
    }
    
}
