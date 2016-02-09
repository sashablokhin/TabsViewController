//
//  Extensions.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 09.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


extension UINavigationBar {
    func setContentAlpha(alpha: CGFloat) {
        
        let navItem = self.items?.first
        
        setItemsAlpha(navItem?.leftBarButtonItems, alpha: alpha)
        setItemsAlpha(navItem?.rightBarButtonItems, alpha: alpha)
        
    }
    
    private func setItemsAlpha(barButtonItems: [UIBarButtonItem]?, alpha: CGFloat) {
        if let items = barButtonItems {
            for item in items {
                item.customView?.alpha = alpha
            }
        }
    }
}


