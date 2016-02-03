//
//  TabsViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 02.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class TabItem: NSObject {
    var imageNormal: UIImage?
    var imageActive: UIImage?
    var title: String?
    var viewController: UIViewController!
}

@objc protocol TabsViewControllerDelegate {
    optional func tabsViewControllerDidMoveToTab(tabsViewController: TabsViewController, tab: TabItem, atIndex: Int)
}

class TabsViewController: UIViewController, UIScrollViewDelegate, TabsScrollViewDelegate {
    
    var tabs: [TabItem]!
    var contentScrollView: UIScrollView!
    
    var tabsScrollView: TabsScrollView!
    
    var delegate: TabsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    init(parent: UIViewController, tabs: [TabItem]) {
        super.init(nibName: nil, bundle: nil)
        self.tabs = tabs
        
        // Move to parent
        
        willMoveToParentViewController(parent)
        parent.addChildViewController(self)
        didMoveToParentViewController(parent)
        
        // Setup views
        
        tabsScrollView = TabsScrollView(width: view.frame.width, tabs: tabs)
        tabsScrollView.frame.origin.y = parent.topLayoutGuide.length
        tabsScrollView.tabsDelegate = self
        
        contentScrollView = UIScrollView(frame: view.frame)
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.pagingEnabled = true
        contentScrollView.scrollsToTop = false
        contentScrollView.contentSize.width = contentScrollView.frame.width * CGFloat(tabs.count)
        contentScrollView.delegate = self
        
        view.addSubview(contentScrollView)
        view.addSubview(tabsScrollView)
        
        // Add child view controllers
        
        var currentX: CGFloat = 0
        
        for tab in tabs {
            tab.viewController.view.frame = CGRectMake(currentX, parent.topLayoutGuide.length, view.frame.width, view.frame.height - parent.topLayoutGuide.length - parent.bottomLayoutGuide.length)
            
            contentScrollView.addSubview(tab.viewController.view)
            
            currentX += contentScrollView.frame.width
        }
        
        // Move First Item
        
        setCurrentViewControllerAtIndex(0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCurrentViewControllerAtIndex(index: Int) {
        
        let viewController = tabs[index].viewController
        
        viewController.willMoveToParentViewController(self)
        addChildViewController(viewController)
        viewController.didMoveToParentViewController(self)
        
        delegate?.tabsViewControllerDidMoveToTab!(self, tab: tabs[index], atIndex: index)
        
        tabsScrollView.selectItemAtIndex(index)
        contentScrollView.setContentOffset(CGPoint (x: contentScrollView.frame.width * CGFloat(index), y: 0), animated: true)
    }
    
    
    // MARK: TabsScrollViewDelegate
    
    func tabsScrollViewDidPressed(tabsScrollView: TabsScrollView, atIndex: Int) {
        //tabsScrollView.shouldSlide = false
        setCurrentViewControllerAtIndex(atIndex)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let panState = scrollView.panGestureRecognizer.state
        
        if panState == .Began {
            tabsScrollView.shouldSlide = true
        }
        
        let contentW = contentScrollView.contentSize.width - contentScrollView.frame.size.width
        let sliderW = tabsScrollView.contentSize.width - tabsScrollView.frame.size.width
        
        let current = contentScrollView.contentOffset.x
        let ratio = current / contentW
        
        if tabsScrollView.contentSize.width > tabsScrollView.frame.size.width && tabsScrollView.shouldSlide == true {
            tabsScrollView.contentOffset = CGPoint (x: sliderW * ratio, y: 0)
        }
        
        if scrollView.tracking || scrollView.dragging || scrollView.decelerating  {
            let selectorW = tabsScrollView.contentSize.width  - tabsScrollView.selector.frame.width
            tabsScrollView.selector.frame.origin.x = selectorW * ratio
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / contentScrollView.frame.width
        setCurrentViewControllerAtIndex(Int(index))
    }
}












