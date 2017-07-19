//
//  ViewController.swift
//  CPCBannerView
//
//  Created by 鹏程 on 17/7/18.
//  Copyright © 2017年 CPC-Coder. All rights reserved.
//

import UIKit


let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height



/*
 CPCBannerViewDefault --> collectionView上有lab (所有cell共享控件) (故对view设置属性)
 CPCBannerViewCustom  --> 每个cell上都有lab(cell都有独有控件) (故对cell设置属性)
 CPCBannerViewTextOnly --> 只有文字
 */

class ViewController: UIViewController {
    
    var imageNames = ["0","1","2","3"] {
        didSet{
            view1.reload()
        }
    }
    
    
    fileprivate lazy var view1: CPCBannerViewDefault = CPCBannerViewDefault(delegate: self as CPCBannerViewDelegate)
    fileprivate lazy var view2: CPCBannerViewCustom = CPCBannerViewCustom(delegate: self as CPCBannerViewDelegate)
    fileprivate lazy var view3: CPCBannerViewTextOnly = CPCBannerViewTextOnly(delegate: self as CPCBannerViewDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        /*--------          推荐用CPCBannerViewDefault          --------*/
        //CPCBannerViewDefault
        view1.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH/3)
        view1.tag = 1
        view1.isOnlyImg = false //默认只有图片
        view1.scrollDirection = .vertical//方向
        view1.pageControlPositon = .bottomRight//pageControl位置
        view1.scrollDuration = 2 //时间
        
        view.addSubview(view1)
        
        
        
        //CPCBannerViewCustom
        view2.frame = CGRect(x: 0, y: kScreenH/3, width: kScreenW, height: kScreenH/3)
        view2.tag = 2
        view.addSubview(view2)
        
        
        
        //CPCBannerViewTextOnly
        view3.frame = CGRect(x: 0, y: kScreenH/3*2, width: kScreenW, height: kScreenH/3)
        view3.tag = 3
        view.addSubview(view3)
        
        
        
        
        
        
        
        
       
        
    }
    
    
   
    
    
}




extension ViewController:CPCBannerViewDelegate{
    func c_numberOfPages(bannerView: CPCBaseBannerView) -> Int {
        return imageNames.count
    }
    
    
    func c_setUpPageCell(bannerView: CPCBaseBannerView, cell: UICollectionViewCell, index: Int) {
        
        switch bannerView.tag {
        case 1:
            let cell = cell as! CPCBannerViewDefaultCell
            cell.imgV.image = UIImage(named: "\(imageNames[index])")
            
        case 2:
            let cell = cell as! CPCBannerViewCustomCell
            cell.type = .imgAndText//CPCBannerViewCustomCell专用
            cell.lab.text = "CustomCell这是\(index)页"
            cell.imgV.image = UIImage(named: "\(imageNames[index])")
            
            
        case 3:
            let cell = cell as! CPCBannerViewTextOnlyCell
            
            cell.lab.text = "TextOnlyCell-这是\(index)页"
            
        default:
            return
        }
        
        
        
    }
    
    
    
    
    
    //CPCBannerViewDefaultCell专有
    func c_setUpLab(bannerView: CPCBaseBannerView, index: Int) -> String {
        
        
        return "CPCBannerViewDefault-这是\(index)页"
    }
    
    
    
    func c_didSelectPage(bannerView: CPCBaseBannerView, index: Int) {
        print("点击了\(index)")
        
        imageNames.append("0")
        
        //FIXME: 修改了imageNames 要调用reload  (因为继承UICollectionView)
        view1.reload()
        view2.reload()
        view3.reload()
        
        
        
    }
}

