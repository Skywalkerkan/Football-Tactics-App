//
//  CustomLayout.swift
//  Football Tactics App
//
//  Created by Erkan on 2.01.2024.
//

import UIKit



class CustomLayout: UICollectionViewFlowLayout{
    
    
    var previousOffset: CGFloat = 0.0
    var currentPage = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else{
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemCount = cv.numberOfItems(inSection: 0)
        
        if previousOffset > cv.contentOffset.x && velocity.x < 0.0{
            currentPage = max(currentPage-1, 0)
        }else{
            currentPage = min(currentPage+1, itemCount-1)
        }
        
        /*let width = cv.frame.width
        let itemWidth = itemSize.width
        let sp = minimumLineSpacing
        let edge = (width - itemWidth - sp*2)/2*/
        let offset = updateOffset(cv)
        
        previousOffset = offset
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
    
    
    func updateOffset(_ cv: UICollectionView) -> CGFloat{
        let width = cv.frame.width
        let itemWidth = itemSize.width
        let sp = minimumLineSpacing
        let edge = (width - itemWidth - sp*2)/2
        let offset = (itemWidth + sp) * CGFloat(currentPage) - (edge + sp)
        return offset
    }
    
    
}
