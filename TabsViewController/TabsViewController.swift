//
//  TabsViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 02.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

var navigationBar: UINavigationBar!
var tabsViewController: TabsViewController!

class TabItem: NSObject {
    var imageNormal: UIImage?
    var imageActive: UIImage?
    var title: String?
    var viewController: UIViewController!
}

@objc protocol TabsViewControllerDelegate {
    optional func tabsViewControllerDidMoveToTab(tabsViewController: TabsViewController, tab: TabItem, atIndex: Int)
}

@objc protocol HiddenNavigationBarScrollViewDelegate {
    optional func hiddenNavigationBarScrollViewDidScroll(scrollView: UIScrollView)
    optional func hiddenNavigationBarScrollViewDidEndDecelerating(scrollView: UIScrollView)
    optional func hiddenNavigationBarScrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

protocol HiddenNavigationBarProtocol {
    var hiddenNavigationBarDelegate: HiddenNavigationBarScrollViewDelegate? {get set}
}

class TabsViewController: UIViewController, UIScrollViewDelegate, TabsScrollViewDelegate, HiddenNavigationBarScrollViewDelegate {
    
    var tabs: [TabItem]!
    var contentScrollView: UIScrollView!
    
    var tabsScrollView: TabsScrollView!
    
    var delegate: TabsViewControllerDelegate?
    
    private var previousYOffset = CGFloat.NaN

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
        tabsScrollView.tabsDelegate = self
        
        view.addSubview(tabsScrollView)
        
        contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height))
        
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.pagingEnabled = true
        contentScrollView.scrollsToTop = false
        contentScrollView.contentSize.width = contentScrollView.frame.width * CGFloat(tabs.count)
        
        contentScrollView.delegate = self
        
        view.addSubview(contentScrollView)
        
        // Add child view controllers
        
        var currentX: CGFloat = 0
        
        for tab in tabs {
            tab.viewController.view.frame = CGRectMake(currentX, 0, view.frame.width, view.frame.height)
            
            if var vc = tab.viewController as? HiddenNavigationBarProtocol {
                vc.hiddenNavigationBarDelegate = self
            }
            
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
    
    
    
    // MARK: - HiddenNavigationBarScrollViewDelegate
    
    func hiddenNavigationBarScrollViewDidScroll(scrollView: UIScrollView) {
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
    
    func hiddenNavigationBarScrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func hiddenNavigationBarScrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            stoppedScrolling()
        }
    }
    
    
    // MARK: - Supporting functions
    
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












