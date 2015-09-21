//
//  WaterLayout.swift
//  WaterFallDynamic
//
//  Created by Ronaldinho on 15/9/17.
//  Copyright © 2015年 龙龙工作室. All rights reserved.
//

import UIKit
protocol WaterfallProtocol : class{
    func collectionView_heightForItemAtIndexPath(view:UICollectionView,layout:WaterLayout,path:NSIndexPath)->Float
     func waterfall_itemWidth(itemWidth:Float)
}
class WaterLayout: UICollectionViewLayout {
    var m_numberOfColums  = 2
    var m_interItemSpacing = 10
    var m_allItemAttributeArray = NSMutableArray()
    var m_everyColumsHeightDic = NSMutableDictionary()
    weak var delegate : WaterfallProtocol?
    override func prepareLayout(){
        super.prepareLayout()
        let cvWidth =  Float(collectionView!.bounds.size.width)
        let itemWidth = (cvWidth - (Float(m_interItemSpacing) * (Float(m_numberOfColums) + 1))) / Float(m_numberOfColums)
        //重新布局前 重置
        m_allItemAttributeArray.removeAllObjects()
        (collectionView!.delegate as! WaterfallProtocol).waterfall_itemWidth(itemWidth)
        //初始化每列的原始高度
        for i in 0..<m_numberOfColums{
            m_everyColumsHeightDic.setObject(NSNumber(float: 0.0), forKey: i.description)
        }
        //每个分区的视图总数，为简化起见，将定只有一个分区
        let itemCount = collectionView!.numberOfItemsInSection(0)
        for i in 0..<itemCount{
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            //得到高度最短的列
            let minHeightColum = getMinHeightColum()
            //视图的frame_x
            let x = Float(m_interItemSpacing) + (Float(m_interItemSpacing) + itemWidth) * Float(minHeightColum)
            //视图的frame_y
            var y = m_everyColumsHeightDic[minHeightColum.description]!.floatValue
            //视图的frame_height，是向代理对象（使用改布局方式的CollectonView的代理对象，这里只做一下强转）询问的视图的高度
            let heightDelegate = collectionView!.delegate as! WaterfallProtocol
            let itemHeight = heightDelegate.collectionView_heightForItemAtIndexPath(collectionView!, layout: self, path: indexPath)
            //生成布局信息
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attribute.frame = CGRectMake(CGFloat(x), CGFloat(y), CGFloat(itemWidth), CGFloat(itemHeight))
            m_allItemAttributeArray.addObject(attribute)
            y = y + Float(m_interItemSpacing)
            y = y + Float(itemHeight)
            //跟新每列的高度信息
            m_everyColumsHeightDic.setObject(NSNumber(float: y), forKey: minHeightColum.description)
        }
        
        
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]{
        var array = Array<UICollectionViewLayoutAttributes>()
        
        m_allItemAttributeArray.enumerateObjectsUsingBlock { (attribute, idx, stop) -> Void in
            if CGRectIntersectsRect(rect, attribute.frame){
                 array.append(attribute as! UICollectionViewLayoutAttributes)
            }
        }
        return array
    }
    override func collectionViewContentSize() -> CGSize{
        return CGSizeMake(collectionView!.frame.size.width, CGFloat(m_everyColumsHeightDic[getMaxHeightColum().description]!.floatValue))
    }
}
extension WaterLayout{
    //获取最短列
    func getMinHeightColum()->Int{
        let count = m_everyColumsHeightDic.count
        var minIndex = 0
        var minHeight = m_everyColumsHeightDic["0"]!.floatValue
        for i in 1..<count{
            if  m_everyColumsHeightDic[NSNumber(integer: i).description]!.floatValue<minHeight{
                minHeight = m_everyColumsHeightDic[NSNumber(integer: i).description]!.floatValue
                minIndex = i
            }
        }
        return minIndex
    }
    //获取最长列
    func getMaxHeightColum()->Int{
        let count = m_everyColumsHeightDic.count
        var maxIndex = 0
        var maxHeight = m_everyColumsHeightDic["0"]!.floatValue
        for i in 1..<count{
            if m_everyColumsHeightDic[NSNumber(integer: i).description]!.floatValue>maxHeight{
                maxHeight = m_everyColumsHeightDic[NSNumber(integer: i).description]!.floatValue
                maxIndex = i
            }
        }
        return maxIndex
    }
}