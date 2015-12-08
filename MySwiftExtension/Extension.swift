//
//  Extension.swift
//  LayoutSample
//
//  Created by kingkong999yhirose on 2015/11/03.
//  Copyright © 2015年 kingkong999yhirose. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func topViewController() -> UIViewController? {
        if var topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while (topViewController.presentedViewController != nil) {
                topViewController = topViewController.presentedViewController!
            }
            return topViewController
        } else {
            return nil
        }
    }
}

extension NSObject {
    var className: String {
        get {
            let className = NSStringFromClass(self.dynamicType)
            let range = className.rangeOfString(".")
            return className.substringFromIndex(range!.endIndex)
        }
    }
    class var className: String {
        get {
            let className = NSStringFromClass(self)
            let range = className.rangeOfString(".")
            return className.substringFromIndex(range!.endIndex)
        }
    }
}

protocol StoryboardInitializable {
    
}

extension StoryboardInitializable where Self: UIViewController {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.className, bundle: nil)
    }
    
    static func viewController() -> Self {
        let storyboard = self.storyboard()
        let viewController = storyboard.instantiateInitialViewController() as! Self
        return viewController
    }
}

extension UIViewController : StoryboardInitializable {
    
   
}

protocol XibInitializable {
}

extension XibInitializable where Self: UIView {
    static func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
    
    static func view() -> Self {
        let nib = self.nib()
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! Self
        return view
    }
}
extension UIView : XibInitializable {
}

extension UITableView {
    func registerNib<T: UITableViewCell>(type: T.Type) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: className)
    }
    
    func dequeueCell<T: UITableViewCell>(type: T.Type, indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(type.className, forIndexPath: indexPath) as! T
    }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(type: T.Type) {
        let className = type.className
        let nib = UINib(nibName: type.className, bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: className)
    }
    
    func registerReusableNib<T: UICollectionReusableView>(type: T.Type, kind: String) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        registerNib(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithReuseIdentifier(type.className, forIndexPath: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(kind: String, type: T.Type, indexPath: NSIndexPath) -> T {
        return dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: type.className,
            forIndexPath: indexPath) as! T
    }
}


