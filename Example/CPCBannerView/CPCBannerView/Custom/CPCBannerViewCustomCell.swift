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


public class CPCBannerViewCustomCell: UICollectionViewCell {
    
    var type : CPCBannerViewCustomType = .img{
        didSet{
            
            
            lab.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            lab.textColor = UIColor.white
            switch type {
            case .img:
                
                imgV.isHidden = false
                lab.isHidden = true
                
            case .text:
                lab.backgroundColor = UIColor.white
                lab.textColor = UIColor.black
                imgV.isHidden = true
                lab.isHidden = false
                
            case .imgAndText:
                imgV.isHidden = false
                lab.isHidden = false
                
            }
            //layoutIfNeeded()
        }
    }
    
     lazy var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleToFill
        imgV.clipsToBounds = true
        return imgV
      
    }()
    
     lazy var lab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.adjustsFontSizeToFitWidth = true
        lab.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        lab.textColor = UIColor.white
        return lab
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
        addSubview(lab)
        
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch type {
        case .img:
           imgV.frame = bounds
            
        case .text:
            
            
            lab.frame = bounds
            
        case .imgAndText:
            imgV.frame = bounds
            let h:CGFloat = 37
            lab.frame = CGRect(x: 0, y: bounds.height-h, width: bounds.width, height: h)
            
        }
        
        
        
    }
    
}
