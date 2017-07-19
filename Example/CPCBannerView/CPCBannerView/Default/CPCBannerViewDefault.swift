//
//  CPCBannerViewDefault.swift
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

class CPCBannerViewDefault: CPCBaseBannerView {
    
    
    
    
    //MARK: - *** 公开属性 ***
    var isOnlyImg = true{
        didSet{
            lab.isHidden = isOnlyImg
        }
    }
    
    
    lazy var lab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.adjustsFontSizeToFitWidth = true
        lab.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        lab.textColor = UIColor.white
        return lab
    }()
    
    
    
    //MARK: - *** 私有属性 ***
  fileprivate  let cellID = "CPCBannerViewCustomCellID"
    
    
    
    
    override init(delegate: CPCBannerViewDelegate) {
        
        super.init(delegate: delegate)
        lab.isHidden = isOnlyImg
        lab.text = delegate.c_setUpLab?(bannerView: self, index: 0)
        addSubview(lab)
        bringSubview(toFront: pageControl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 重写父类方法
    override func registerCell(collectionView: UICollectionView) {
        
        collectionView.register(CPCBannerViewDefaultCell.self, forCellWithReuseIdentifier: cellID)
     
    }
    
    override func dequeueReusableCell(collectionView: UICollectionView, indexPath: IndexPath) -> (UICollectionViewCell) {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelHeight:CGFloat = 37
        lab.frame = CGRect(x: 0, y: bounds.height-labelHeight, width: bounds.width, height: labelHeight)
        
    }
    
    
    
    // 改变当前下标的时候, 调用代理方法设置新数据
    override func change(currentPage: Int) {
        super.change(currentPage: currentPage)
        
        if !isOnlyImg {
            lab.text = delegate?.c_setUpLab?(bannerView: self, index: currentPage)
        }
      
        
    }
    

    

    
}



