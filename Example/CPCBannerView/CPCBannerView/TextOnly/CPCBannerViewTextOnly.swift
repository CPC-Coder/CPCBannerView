//
//  CPCBannerViewTextOnly.swift
//  bannerView
//
//  Created by 鹏程 on 17/7/5.
//  Copyright © 2017年 pengcheng. All rights reserved.
//

import UIKit

public class CPCBannerViewTextOnly: CPCBaseBannerView {

    let cellID = "CPCBannerViewTextOnlyCellID"
    
    override init(delegate: CPCBannerViewDelegate) {
        super.init(delegate: delegate)
        
        pageControl.isHidden = true
        backgroundColor = UIColor.white
        scrollDirection = .vertical
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 重写父类方法
    override func registerCell(collectionView: UICollectionView) {
        
        collectionView.register(CPCBannerViewTextOnlyCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func dequeueReusableCell(collectionView: UICollectionView, indexPath: IndexPath) -> (UICollectionViewCell) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)

        
        return cell
        
    }

    
   
    
    
    



}
