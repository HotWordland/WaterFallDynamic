//
//  ViewController.swift
//  WaterFallDynamic
//
//  Created by Ronaldinho on 15/9/17.
//  Copyright © 2015年 龙龙工作室. All rights reserved.
//
import Alamofire
import UIKit

class NetImageVC: UIViewController{
    
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
    var loadActivityView : DTIActivityIndicatorView?
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CV.delegate = self
        CV.dataSource = self
        confirRefreshHeader()
        confirLoadActivity()
        request(page)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NetImageVC:UICollectionViewDelegate,UICollectionViewDataSource,WaterfallProtocol{
    //请求方法
    func request(p:Int){
        loadActivityView?.startActivity()
        var tempArray = NSArray();
        Alamofire.request(.GET, String.request_string(String(p))).responseJSON { (_, _, result) -> Void in
            print(result)
            if let dicValue = result.value{
                if dicValue.isKindOfClass(NSDictionary){
                    if let value = dicValue.objectForKey("info"){
                        if value as! String == "no more data"{
                            NSLog("no more data")
                            let alert = UIAlertView(title: "提示", message: "无更多数据", delegate: nil, cancelButtonTitle: "好")
                            alert.show()
                            if self.refreshState == RefreshStateNormal || self.refreshState == RefreshStatePull{
                                self.performSelector("doneWithView:", withObject: self.header, afterDelay: 2.0)
                            }else if self.refreshState == RefreshStateUp{
                                self.performSelector("doneWithView:", withObject: self.footer, afterDelay: 2.0)
                            }
                            return
                        }
                    }                }
                
            }else{
                NSLog("no data")
                let alert = UIAlertView(title: "提示", message: "无法请求数据,确认服务器情况", delegate: nil, cancelButtonTitle: "好")
                alert.show()
                if self.refreshState == RefreshStateNormal || self.refreshState == RefreshStatePull{
                    self.performSelector("doneWithView:", withObject: self.header, afterDelay: 2.0)
                }else if self.refreshState == RefreshStateUp{
                    self.performSelector("doneWithView:", withObject: self.footer, afterDelay: 2.0)
                }

                return
            }
            tempArray = result.value as! NSArray
            debugPrint(result)
            if self.refreshState == RefreshStateNormal{
                let temp = NSMutableArray(array: tempArray)
                self.dataSource = temp
                let tempAni = NSMutableArray()
                for _ in 0..<self.dataSource.count{
                    tempAni.addObject("false")
                }
                self.controlAnim = tempAni
                self.performSelector("doneWithView:", withObject: self.header, afterDelay: 2.0)
            }else if self.refreshState == RefreshStatePull{
                let temp = NSMutableArray(array: tempArray)
                self.dataSource = temp
                let tempAni = NSMutableArray()
                for _ in 0..<self.dataSource.count{
                    tempAni.addObject("false")
                }
                self.controlAnim = tempAni
                self.performSelector("doneWithView:", withObject: self.header, afterDelay: 2.0)
            }else if self.refreshState == RefreshStateUp{
                self.dataSource.addObjectsFromArray(tempArray as [AnyObject])
                let tempAni = NSMutableArray()
                for _ in 0..<self.dataSource.count{
                    tempAni.addObject("false")
                }
                self.controlAnim.addObjectsFromArray(tempAni as [AnyObject])
                self.performSelector("doneWithView:", withObject: self.footer, afterDelay: 2.0)
            }
            
        }
    }
    //配置请求的activity
    func confirLoadActivity(){
        loadActivityView = DTIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        self.view.addSubview(loadActivityView!)
        loadActivityView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([NSLayoutConstraint(item: loadActivityView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: loadActivityView!.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0),NSLayoutConstraint(item: loadActivityView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: loadActivityView!.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: loadActivityView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100),NSLayoutConstraint(item: loadActivityView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100)])
        loadActivityView!.indicatorColor = UIColor.purpleColor();
        loadActivityView!.indicatorStyle = "wave";
        loadActivityView!.backgroundColor = UIColor.clearColor();
    }
    //UICollectionViewDataSource 代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WaterCell", forIndexPath: indexPath) as! WaterCell
      
        let imgUrl = dataSource[indexPath.row]["img_path"] as! String
        cell.lblContent.text = dataSource[indexPath.row]["img_theme"] as? String
        cell.IM.sd_setImageWithURL(NSURL(string: imgUrl), completed: { (image, _, _, _) -> Void in
        cell.IM.image = image


            })
                if controlAnim[indexPath.row] as! String == "false"{
                   displayCellAnimation(cell.contentView)
                    controlAnim[indexPath.row] = "true"
                }
        
        
        return cell
    }
    //动画
    func displayCellAnimation(view:UIView){
        view.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.transform = CGAffineTransformIdentity
            
            }) { (success) -> Void in
                
        }
    }
    //waterfallProtocol询问cell高度的代理
    func collectionView_heightForItemAtIndexPath(view: UICollectionView, layout: WaterLayout, path: NSIndexPath) -> Float {
               let origiImageWidth = dataSource[path.row]["width"] as! NSString
        let origiImageHeight = dataSource[path.row]["height"] as! NSString
        //按比例收缩
        let cellItemHeight = CGFloat(origiImageHeight.floatValue) * (CGFloat(cellItemWidth - 20)/CGFloat(origiImageWidth.floatValue))
        return Float(cellItemHeight +  CGFloat(58))

        
    }
    //获取cell的width 从layout里面
    func waterfall_itemWidth(itemWidth: Float) {
        cellItemWidth = itemWidth
    }
    func addHeader(){
        header = WLFreshHeaderView.header()
        header!.scrollView = CV
    }
    //配置刷新的activity
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
         
            self.refreshState = RefreshStatePull
            self.page = 1
            self.request(self.page)
            self.headerActivityView!.startActivity()
            
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
                      ++self.page
            self.refreshState = RefreshStateUp
            self.request(self.page)
            
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
        self.loadActivityView?.stopActivity()
        refreshView.endRefreshing()
        CV.reloadData()
    }
}
