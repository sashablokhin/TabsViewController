//
//  TableViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 03.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


class PopularTableViewController: UITableViewController, HiddenNavigationBarProtocol {
    
    var hiddenNavigationBarDelegate: HiddenNavigationBarScrollViewDelegate?

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

        cell.textLabel?.text = "Популярное \(indexPath.row)"
        
        return cell
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        tableView.contentInset.bottom = tabsViewController.tabsScrollView.frame.height + 20
        hiddenNavigationBarDelegate?.hiddenNavigationBarScrollViewDidScroll!(scrollView)
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        hiddenNavigationBarDelegate?.hiddenNavigationBarScrollViewDidEndDecelerating!(scrollView)
    }
    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        hiddenNavigationBarDelegate?.hiddenNavigationBarScrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
    }
}











