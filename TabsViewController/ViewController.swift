//
//  ViewController.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 02.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.text = "Главная"
        titleLabel.textColor = UIColor.whiteColor()
        //titleLabel.font = UIFont(name: "System", size: 17)!
        titleLabel.sizeToFit()
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


}

