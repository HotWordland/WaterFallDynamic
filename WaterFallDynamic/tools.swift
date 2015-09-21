//
//  tools.swift
//  WaterFallDynamic
//
//  Created by Ronaldinho on 15/9/18.
//  Copyright © 2015年 龙龙工作室. All rights reserved.
//

import Foundation
import UIKit
let Domain_string = "http://localhost/"
var Request_String_Page = Domain_string + "MyThinkingPhp/Home/WaterFallDynamicList/index/p/"
extension UIImage {
    func resizeToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension String{
    static func request_string(p : String) -> String {
        return Request_String_Page + p
    }
}