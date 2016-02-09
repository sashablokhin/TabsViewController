//
//  TableViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 03.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    private var previousYOffset = CGFloat.NaN

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 36
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {

        tableView.contentInset.bottom = tabsViewController.tabsScrollView.frame.height + 20
        
        var frame = navigationBar.frame
        let size = frame.size.height - 21
        let framePercentageHidden = ((-frame.origin.y) / (frame.size.height - 1))
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousYOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = 0
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            frame.origin.y = -size
        } else {
            frame.origin.y = min(0, max(-size, frame.origin.y - scrollDiff))
        }
        
        navigationBar.frame = frame
        navigationBar.setContentAlpha(1 - framePercentageHidden)
        
        self.previousYOffset = scrollOffset
        
        tabsViewController.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: tabsViewController.view.frame.width, height: tabsViewController.view.frame.height)
    }
    
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stoppedScrolling()
    }
    

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            stoppedScrolling()
        }
    }
    
    
    func stoppedScrolling()
    {
        let frame = navigationBar.frame
        if (frame.origin.y < 0) {
            animateNavBarTo(-(frame.size.height - 21))
        }
    }
    
    
    func animateNavBarTo(y: CGFloat)
    {
        UIView.animateWithDuration(0.2) { () -> Void in
            var frame = navigationBar.frame
            
            let alpha: CGFloat = (frame.origin.y >= y ? 0 : 1)
            
            frame.origin.y = y
            
            navigationBar.frame = frame
            navigationBar.setContentAlpha(alpha)
            
            tabsViewController.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: tabsViewController.view.frame.width, height: tabsViewController.view.frame.height)
        }
    }
}



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







