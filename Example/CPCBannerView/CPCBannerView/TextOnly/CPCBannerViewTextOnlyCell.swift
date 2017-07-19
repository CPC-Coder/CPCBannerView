//
//  CPCBannerTextOnly.swift
//  bannerView
//
//  Created by 鹏程 on 17/7/5.
//  Copyright © 2017年 pengcheng. All rights reserved.
//




/*--------          温馨提示          --------*/
/*
 CPCBannerViewDefault --> 每个cell上都有lab(cell都有独有控件)
 CPCBannerViewCustom  --> collectionView上有lab (所有cell共享控件)
 CPCBannerViewTextOnly -->
 */
/*--------          温馨提示          --------*/




import UIKit

public class CPCBannerViewTextOnlyCell: UICollectionViewCell {
    
    
    
     lazy var lab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black
        lab.backgroundColor = UIColor.white
        
        
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(lab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lab.frame = bounds
        
        
        
    }
    
    
    
}
