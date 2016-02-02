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
        
        titleLabel.textColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let searchButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchButton.setImage(UIImage(named: "search.png"), forState: UIControlState.Normal)
        //searchButton.addTarget(self, action: "searchButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        let menuButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        menuButton.setImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        //menuButton.addTarget(self, action: "menuButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton), UIBarButtonItem(customView: searchButton)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        let tab1 = TabItem()
        tab1.image = UIImage(named: "home_black")
        tab1.title = "Главная"
        tab1.viewController = viewControllerWithColorAndTitle(UIColor.orangeColor(), title: "")
        
        let tab2 = TabItem()
        tab2.image = UIImage(named: "fire_black")
        tab2.title = "Популярное"
        tab2.viewController = viewControllerWithColorAndTitle(UIColor.brownColor(), title: "")
        
        let tab3 = TabItem()
        tab3.image = UIImage(named: "play_black")
        tab3.title = "Подписки"
        tab3.viewController = viewControllerWithColorAndTitle(UIColor.greenColor(), title: "")
        
        let tab4 = TabItem()
        tab4.image = UIImage(named: "user_black")
        tab4.title = "Аккаунт"
        tab4.viewController = viewControllerWithColorAndTitle(UIColor.blueColor(), title: "")
        
        let tabsViewController = TabsViewController(parent: self, tabs: [tab1, tab2, tab3, tab4])
        tabsViewController.delegate = self
        
        view.addSubview(tabsViewController.view)
        
        //tabsViewController.sliderView.appearance.outerPadding = 0
        //tabsViewController.sliderView.appearance.innerPadding = 50
        
        tabsViewController.setCurrentViewControllerAtIndex(0)
    }
    
    func viewControllerWithColorAndTitle(color: UIColor, title: String) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = color
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(25)
        titleLabel.sizeToFit()
        titleLabel.center = view.center
        
        viewController.view.addSubview(titleLabel)
        
        return viewController
    }
    
    // MARK: - TabsViewControllerDelegate
    
    func tabsViewControllerDidMoveToTab(tabsViewController: TabsViewController, tab: TabItem, atIndex: Int) {
        titleLabel.text = tab.title
        titleLabel.sizeToFit()
    }

}









