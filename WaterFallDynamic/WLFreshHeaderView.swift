//
//  WLFreshHeaderView.swift
//  WaterFallDynamic
//
//  Created by Ronaldinho on 15/9/18.
//  Copyright © 2015年 龙龙工作室. All rights reserved.
//

import UIKit

class WLFreshHeaderView: MJRefreshHeaderView {
    
    /* 本来是写继承写重载的 但是继承了OC中的类 swift怎么也重载不了OC父类中的方法(not call override func) 如有大神知道请指教
    let  activityView  = DTIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
       override  func subToAddElement(){
        super.subToAddElement()
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: activityView.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 50),NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: activityView.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40),NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)])
    }
    override func endRefreshing() {
        super.endRefreshing()
        NSLog("父类重写endRefreshing方法")
        
     
    }
     override func newAddElement()-> Void {
    
    }
    override func normalStateAction(){
        activityView.stopActivity()
    }
    override func refreshingStateAction() {
        activityView.startActivity()
    }
*/
}
