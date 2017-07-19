//
//  CPCBannerViewDefaultCellCollectionViewCell.swift
//  bannerView
//
//  Created by 鹏程 on 17/7/5.
//  Copyright © 2017年 pengcheng. All rights reserved.
//




/*--------          温馨提示          --------*/
/*
 CPCBannerViewDefault --> collectionView上有lab (所有cell共享控件)
 CPCBannerViewCustom  --> 每个cell上都有lab(cell都有独有控件)
 CPCBannerViewTextOnly --> 只有文字
 */
/*--------          温馨提示          --------*/



import UIKit

public class CPCBannerViewDefaultCell: UICollectionViewCell {
    
    
    
     lazy var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleToFill
        imgV.clipsToBounds = true
        return imgV
      
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setupUI() -> () {
        addSubview(imgV)
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgV.frame = bounds
        
     
        
    }
    
}
