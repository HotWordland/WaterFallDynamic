//
//  LocalImageVC.swift
//  WaterFallDynamic
//
//  Created by Ronaldinho on 15/9/21.
//  Copyright © 2015年 龙龙工作室. All rights reserved.
//

import UIKit

class LocalImageVC: UIViewController {

    @IBOutlet weak var CV: UICollectionView!
    var cellItemWidth = Float(0.0)
    //因为没有重载到OC的方法 所以逼不得已在VC这边写逻辑
    var header : WLFreshHeaderView?
    var footer : MJRefreshFooterView?
    var refreshState = RefreshStateNormal
    var dataSource  = NSMutableArray()
    var controlAnim = NSMutableArray()
    var headerActivityView : DTIActivityIndicatorView?
    var footerActivityView : DTIActivityIndicatorView?
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CV.delegate = self
        CV.dataSource = self
        confirRefreshHeader()
                let tempArray = ["01.jpg","02.jpg","03.jpg","04.jpg","05.jpg","06.jpg","07.jpg","08.jpg","09.jpg","010.jpg"]
                dataSource.addObjectsFromArray(tempArray)
                let tempAni = NSMutableArray()
                for _ in 0..<dataSource.count{
                tempAni.addObject("false")
                }
                controlAnim = tempAni
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LocalImageVC:UICollectionViewDelegate,UICollectionViewDataSource,WaterfallProtocol{
       //UICollectionViewDataSource 代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WaterCell", forIndexPath: indexPath) as! WaterCell
        //重新调整图片的大小  按比例调整到宽度为cellItemWidth的情况
          cell.IM.image = UIImage(named: dataSource[indexPath.row] as! String)!
        if controlAnim[indexPath.row] as! String == "false"{
            displayCellAnimation(cell.contentView)
            controlAnim[indexPath.row] = "true"
        }
        
        
        return cell
    }
    func displayCellAnimation(view:UIView){
        view.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.transform = CGAffineTransformIdentity
            
            }) { (success) -> Void in
                
        }
    }
    //waterfallProtocol询问cell高度的代理
    func collectionView_heightForItemAtIndexPath(view: UICollectionView, layout: WaterLayout, path: NSIndexPath) -> Float {
        //重新调整图片的大小  按比例调整到宽度为cellItemWidth的情况
                let origiImage = UIImage(named: dataSource[path.row] as! String)!
                let origiImageWidth = UIImage(named: dataSource[path.row] as! String)!.size.width
        
                let cellItemHeight = origiImage.size.height * (CGFloat(cellItemWidth - 20 )/origiImageWidth)
                return Float(cellItemHeight + CGFloat(58))
        
        
    }
    func waterfall_itemWidth(itemWidth: Float) {
        cellItemWidth = itemWidth
    }
    func addHeader(){
        header = WLFreshHeaderView.header()
        header!.scrollView = CV
    }
    func confirDTIActivityView(){
        //header
        headerActivityView = DTIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        header!.addSubview(headerActivityView!)
        headerActivityView!.translatesAutoresizingMaskIntoConstraints = false
        header!.addConstraints([NSLayoutConstraint(item: headerActivityView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: headerActivityView!.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 50),NSLayoutConstraint(item: headerActivityView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: headerActivityView!.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: headerActivityView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40),NSLayoutConstraint(item: headerActivityView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)])
        headerActivityView!.indicatorColor = UIColor.lightGrayColor();
        headerActivityView!.indicatorStyle = "wp8";
        headerActivityView!.backgroundColor = UIColor.clearColor();
        //footer
        footerActivityView = DTIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        footer!.addSubview(footerActivityView!)
        footerActivityView!.translatesAutoresizingMaskIntoConstraints = false
        footer!.addConstraints([NSLayoutConstraint(item: footerActivityView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: footerActivityView!.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 50),NSLayoutConstraint(item: footerActivityView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: footerActivityView!.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: footerActivityView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40),NSLayoutConstraint(item: footerActivityView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)])
        footerActivityView!.indicatorColor = UIColor.lightGrayColor();
        footerActivityView!.indicatorStyle = "wp8";
        footerActivityView!.backgroundColor = UIColor.clearColor();
    }
    func confirRefreshHeader(){
        addHeader()
        addFooter()
        confirDTIActivityView()
        header!.beginRefreshingBlock = {(refreshView) in
                        let tempArray = ["01.jpg","02.jpg","03.jpg","04.jpg","05.jpg","06.jpg","07.jpg","08.jpg","09.jpg","010.jpg"]
                       self.dataSource.removeAllObjects()
                        self.controlAnim.removeAllObjects()
                        self.dataSource.addObjectsFromArray(tempArray)
                        let tempAni  = NSMutableArray()
                        for _ in 0..<self.dataSource.count{
                            tempAni.addObject("false")
                        }
                        self.controlAnim = tempAni
                        self.performSelector("doneWithView:", withObject: refreshView, afterDelay: 2.0)
        
            
        }
        header!.endStateChangeBlock = {(refreshView) in
            self.headerActivityView!.stopActivity()
            NSLog("刷新完毕")
        }
        header!.refreshStateChangeBlock = { (refreshView,state) in
            if (state == MJRefreshStateNormal){
                NSLog("切换到:普通状态")
                
            }else if(state == MJRefreshStatePulling){
                NSLog("切换到:松开即可刷新的状态")
                
            }else if(state == MJRefreshStateRefreshing){
                NSLog("切换到:刷新完毕")
                
            }
        }
        footer!.beginRefreshingBlock = {
            (refreshView) in
            self.footerActivityView!.startActivity()
                        let tempArray = ["01.jpg","02.jpg","03.jpg","04.jpg","05.jpg","06.jpg","07.jpg","08.jpg","09.jpg","010.jpg"]
                        let tempAni = NSMutableArray()
                        for _ in 0..<tempArray.count{
                           tempAni.addObject("false")
                        }
                        self.controlAnim.addObjectsFromArray(tempAni as [AnyObject])
                        self.dataSource.addObjectsFromArray(tempArray)
                        self.performSelector("doneWithView:", withObject: refreshView, afterDelay: 2.0)
            
            
        }
        footer!.endStateChangeBlock = {
            (refreshView) in
            self.footerActivityView!.stopActivity()
        }
    }
    
    func addFooter(){
        footer = MJRefreshFooterView.footer()
        footer!.scrollView = CV
    }
    func doneWithView(refreshView:MJRefreshBaseView){
        refreshView.endRefreshing()
        CV.reloadData()
    }
}
