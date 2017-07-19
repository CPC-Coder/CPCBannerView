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
enum CPCBannerViewCustomType{
    case img,text,imgAndText
}

class CPCBannerViewCustom: CPCBaseBannerView {
    
    var type : CPCBannerViewCustomType = .img{
        didSet{
            if type == .text {
                scrollDirection = .vertical
                pageControl.isHidden = true
            } else {
                scrollDirection = .horizontal
                pageControl.isHidden = false
            }
            
            
        }
    }
    let cellID = "CPCBannerViewDefaultCellID"
    
    override init(delegate: CPCBannerViewDelegate) {
        super.init(delegate: delegate)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 重写父类方法
    override func registerCell(collectionView: UICollectionView) {
        
        collectionView.register(CPCBannerViewCustomCell.self, forCellWithReuseIdentifier: cellID)
     
    }
    
    override func dequeueReusableCell(collectionView: UICollectionView, indexPath: IndexPath) -> (UICollectionViewCell) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CPCBannerViewCustomCell
        
        
            
        
        
        cell.type = type
        return cell
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

}



