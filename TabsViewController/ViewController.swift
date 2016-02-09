//
//  ViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 02.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


class ViewController: UIViewController, TabsViewControllerDelegate {
    
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        
        titleLabel.textColor = UIColor.whiteColor()
        
        navigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0))
        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor(red: 1, green: 0.0, blue: 0.0, alpha: 1.0)
        
        let navItem = UINavigationItem()
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let searchButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchButton.setImage(UIImage(named: "search.png"), forState: UIControlState.Normal)
        //searchButton.addTarget(self, action: "searchButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        let menuButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        menuButton.setImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        //menuButton.addTarget(self, action: "menuButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        
        navItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton), UIBarButtonItem(customView: searchButton)]
        
        navigationBar.setItems([navItem], animated: true)
        
        self.view.addSubview(navigationBar)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tab1 = TabItem()
        tab1.imageNormal = UIImage(named: "home_black")
        tab1.imageActive = UIImage(named: "home_white")
        tab1.title = "Главная"
        tab1.viewController = viewControllerWithColor(UIColor.orangeColor())
        
        let tab2 = TabItem()
        tab2.imageNormal = UIImage(named: "fire_black")
        tab2.imageActive = UIImage(named: "fire_white")
        tab2.title = "Популярное"
        tab2.viewController = PopularTableViewController()
        //viewControllerWithColor(UIColor.brownColor().colorWithAlphaComponent(0.8))
        
        let tab3 = TabItem()
        tab3.imageNormal = UIImage(named: "play_black")
        tab3.imageActive = UIImage(named: "play_white")
        tab3.title = "Подписки"
        tab3.viewController = SubscribeTableViewController()
        //viewControllerWithColor(UIColor.greenColor().colorWithAlphaComponent(0.5))
        
        let tab4 = TabItem()
        tab4.imageNormal = UIImage(named: "user_black")
        tab4.imageActive = UIImage(named: "user_white")
        tab4.title = "Аккаунт"
        tab4.viewController = viewControllerWithColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
        
        tabsViewController = TabsViewController(parent: self, tabs: [tab1, tab2, tab3, tab4])
        tabsViewController.view.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height)
        tabsViewController.delegate = self
        
        self.view.addSubview(tabsViewController.view)
        
        tabsViewController.tabsScrollView.appearance.outerPadding = 0
        tabsViewController.tabsScrollView.appearance.innerPadding = view.frame.width / 8 //50

        tabsViewController.setCurrentViewControllerAtIndex(0)
    }
    
    func viewControllerWithColor(color: UIColor) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = color
        
        return viewController
    }
    
    // MARK: - TabsViewControllerDelegate
    
    func tabsViewControllerDidMoveToTab(tabsViewController: TabsViewController, tab: TabItem, atIndex: Int) {
        titleLabel.text = tab.title
        titleLabel.sizeToFit()
    }
}









