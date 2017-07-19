//
//  CPCBaseBannerView.swift
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

enum CPCPageControlPosition{
    case bottomCenter,bottomLeft,bottomRight,topCenter,topLeft,topRight
}

/// 如果需要设置可选协议方法
/// - 需要遵守 NSObjectProtocol 协议
/// - 协议需要是 @objc 的
/// - 方法需要 @objc optional


//MARK: - *** 协议 ***
@objc protocol CPCBannerViewDelegate:NSObjectProtocol {
    /**
     *  必须实现的代理方法, 返回总页数
     *
     *  @param bannerView bannerView
     *
     *  @return 返回总页数
     */
    
    //func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func c_numberOfPages(bannerView: CPCBaseBannerView) -> Int
    
    
    
    
    /**
     *  设置cell的数据
     *
     *  @param bannerView bannerView
     *  @param cell    cell的类型由注册的时候决定, 需要转换为相应的类型来使用
     *  @param index   index
     */
    
    //collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func c_setUpPageCell(bannerView:CPCBaseBannerView, cell:UICollectionViewCell,index: Int) -> ()

    

    
    /**
     修改公共控件的数据
     */
    @objc optional func c_setUpLab(bannerView:CPCBaseBannerView,index:Int) -> String
  
    /**
     *  响应点击当前页
     *
     *  @param bannerView
     *  @param index   被点击的index
     */
    @objc optional func c_didSelectPage(bannerView:CPCBaseBannerView, index:Int)

    /**
     *  滚动到当前页
     *
     *  @param bannerView
     *  @param currentIndex currentIndex
     */
    @objc optional func c_didScrollToCurrentIndex(bannerView:CPCBaseBannerView, currentIndex:Int)

}



//MARK: - *** CPCBaseBannerView ***
class CPCBaseBannerView: UIView {

    /** pageControl 的位置 默认为下面居中显示 */
    var pageControlPositon:CPCPageControlPosition = .bottomCenter{
        didSet{
            setNeedsLayout()
        }
    }
    /** 滚动的时间间隔 默认为3s */
    var scrollDuration:Float = 3
    /** 滚动方向 水平或者竖直滚动 默认为水平方向滚动 */
    var scrollDirection:UICollectionViewScrollDirection = .horizontal{
        didSet{
            layout.scrollDirection = scrollDirection
        }
    }
    //代理
    weak var delegate:CPCBannerViewDelegate?
    
    
    
    
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
   
    /** collectionView */
    fileprivate lazy var collectionView: UICollectionView = {[weak self] in
        
        guard let  `self` = self else {
            return UICollectionView()
        }
        
        
        
        //collectionView
       let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        
        v.delegate = self
        v.dataSource = self
        v.isPagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = UIColor.white
        return v
    
        
        
    }()
    /** pageControl */
    lazy var pageControl: UIPageControl = {
        let pageC = UIPageControl()
        pageC.backgroundColor = UIColor.clear
        pageC.currentPageIndicatorTintColor = UIColor.black
        pageC.pageIndicatorTintColor = UIColor.lightGray
        return pageC
        
    }()
    /** 总共的页数 */
    fileprivate var pages:Int = 0{
        didSet{
            pageControl.numberOfPages = pages
        }
    }
    /** 当前的页数 */
    fileprivate var currentPage:Int = 0{
        didSet{
            delegate?.c_didScrollToCurrentIndex?(bannerView: self, currentIndex: currentPage)
            change(currentPage: currentPage)
            pageControl.currentPage = currentPage
            
        }
    }
    

    
    fileprivate var beginOffset: CGPoint = CGPoint.zero
    fileprivate var timer: Timer?
    
    
    
    





    
    
    init(delegate: CPCBannerViewDelegate) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        
        
        
        change(currentPage: currentPage)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    deinit {
        stopTimer()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil{
            stopTimer()
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        let pageControlSize = pageControl.size(forNumberOfPages: pages)
        var pageControlFrame = CGRect(x: 0, y: 0, width: pageControlSize.width, height: pageControlSize.height)
        
        switch pageControlPositon {
        case .topCenter:
            pageControlFrame.origin = CGPoint(x: (bounds.width-pageControlFrame.width)*0.5, y: 0)
        case .topLeft:
            pageControlFrame.origin = CGPoint(x: 0, y: 0)
        case .topRight:
            pageControlFrame.origin = CGPoint(x: bounds.width-pageControlFrame.width, y: 0)
        case .bottomCenter:
            pageControlFrame.origin = CGPoint(x: (bounds.width-pageControlFrame.width)*0.5, y: bounds.height-pageControlFrame.height)
        case .bottomLeft:
            pageControlFrame.origin = CGPoint(x: 0, y: bounds.height-pageControlFrame.height)
        case .bottomRight:
            pageControlFrame.origin = CGPoint(x: bounds.width-pageControlFrame.width, y: bounds.height-pageControlFrame.height)
       
        
        }
        pageControl.frame = pageControlFrame;
        collectionView.frame = self.bounds;
        
        
    }
    //MARK: - *** 图片修改后  必须reload ***
    func reload(){
        stopTimer()
        currentPage = 0
        collectionView.reloadData()
        pages = delegate!.c_numberOfPages(bannerView: self)
        
        startTimer()
        
        
        //        collectionView.reloadData()
        //        collectionView.removeFromSuperview()
        //        pageControl.removeFromSuperview()
        //
        //        setupUI()
        
        
        
    }
    
}




//MARK: - *** 子类实现 ***
extension CPCBaseBannerView {
    
    
    
    func registerCell(collectionView: UICollectionView) -> () {
        
    }
    
    
    func dequeueReusableCell(collectionView: UICollectionView,indexPath:IndexPath)->(UICollectionViewCell){
        
        return UICollectionViewCell()
        
    }
    
    func change(currentPage:Int) -> () {
        
    }
    
    
}



fileprivate extension CPCBaseBannerView {
    
    
    
    func setupUI() -> () {
        guard let delegate = delegate else {
            assert(false, "必须实现代理方法 numberOfPagesForbannerView:")
            return
        }
        
      pages = delegate.c_numberOfPages(bannerView: self)
        // 添加控件
        addSubview(collectionView)
        addSubview(pageControl)
        
        
        // 注册cell
        registerCell(collectionView: collectionView)
        

        // 开启timer
        startTimer()
        
    }
    
    
    

    
    
    



    
    
    
    
}
//MARK: - *** time ***
fileprivate extension CPCBaseBannerView{
    func startTimer(){
        
        
     
        
        if timer == nil && pages>1{
            
               timer = Timer(fireAt: Date()+TimeInterval(scrollDuration), interval: TimeInterval(scrollDuration), target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
            
           
            
            RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
        }
        
        
    }
    
    
    func stopTimer() -> () {

        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerHandler() -> () {
        
        let offset = collectionView.contentOffset
        
        if scrollDirection == .horizontal {
            collectionView.setContentOffset(CGPoint(x: offset.x+collectionView.bounds.width, y: 0), animated: true)
            
            
            
            
        } else {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset.y+collectionView.bounds.height), animated: true)
            
            
        }
        
        
    }
    
    
    
    
    
    
    
}


extension CPCBaseBannerView{
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        beginOffset = scrollView.contentOffset
        stopTimer()
    }
    
    
    
    // 松开手
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offsetX = scrollView.contentOffset.x
        if scrollDirection == .horizontal {
            /*--------                    --------*/
            //向左滑
            if offsetX>scrollView.contentSize.width-scrollView.bounds.width {
                
                // 重置滚动开始的偏移量
                beginOffset.x = 0
                offsetX = beginOffset.x
                // 设置滚动到第一页
                scrollView.setContentOffset(CGPoint(x: beginOffset.x, y: 0), animated: false)
                if !scrollView.isDragging{
                    scrollView.setContentOffset(CGPoint(x: beginOffset.x+scrollView.bounds.width, y: 0), animated: true)
                    
                }
                
                
            }

            

            
            
            
            // 向右滑
            if offsetX<0 {// 滚动到第一页
                
                beginOffset.x = scrollView.contentSize.width-scrollView.bounds.width
                offsetX = beginOffset.x
                // 设置滚动到最后一页
                scrollView.setContentOffset(CGPoint(x: beginOffset.x, y: 0), animated: false)
                
                
            }
            
            var tempIndex = Int(offsetX/scrollView.bounds.width+0.5)
            if tempIndex >= pages{
                tempIndex = 0
            }
            if tempIndex != currentPage{
                currentPage = tempIndex
                
                
            }
            /*--------          <#注释#>          --------*/
        } else {
            /*--------          <#注释#>          --------*/
            var offsetY = scrollView.contentOffset.y
            //向上滑
            if offsetY>scrollView.contentSize.height-scrollView.bounds.height{
                
                beginOffset.y = 0
                offsetY = beginOffset.y
                scrollView.setContentOffset(CGPoint(x: 0, y: beginOffset.y), animated: false)
                
//                if !scrollView.isDragging{
//                    scrollView.setContentOffset(CGPoint(x: 0, y: beginOffset.y+scrollView.bounds.height), animated: true)
//                    currentPage = 1
//                }
                
                
            }
            
            
            
            
            
            
            // 向下滑
            if offsetY<0{
                print("向下滑")
                beginOffset.y = scrollView.contentSize.height-scrollView.bounds.height
                offsetY = beginOffset.y
                scrollView.setContentOffset(CGPoint(x: 0, y: beginOffset.y), animated: false)
                
            }
            
            var tempIndex:Int = Int(offsetY/scrollView.bounds.size.height+0.5)
            if tempIndex>=pages {
                tempIndex = 0
            }
            
            if tempIndex != currentPage {
                currentPage = tempIndex
            }
            
            /*--------          <#注释#>          --------*/
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
}












//MARK: - *** UICollectionViewDelegate DataSource ***
extension CPCBaseBannerView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        var realIndexPath = indexPath
        if indexPath.row == pages{
            realIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        
        
        let cell = dequeueReusableCell(collectionView: collectionView, indexPath: realIndexPath)
        delegate?.c_setUpPageCell(bannerView: self, cell: cell, index: realIndexPath.row)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var realIndexPath = indexPath
        if indexPath.row == pages{
            realIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        
        
        
        
        delegate?.c_didSelectPage?(bannerView: self, index: realIndexPath.row)
        
        
    }
    
    
    
    
    
    
}

extension CPCBaseBannerView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
}


        





