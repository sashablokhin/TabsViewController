//
//  TabsScrollView.swift
//  TabsViewController
//
//  Created by Alexander Blokhin on 02.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

struct TabsScrollViewAppearance {
    
    var backgroundColor: UIColor
    
    var font: UIFont
    var selectedFont: UIFont
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    
    var outerPadding: CGFloat
    var innerPadding: CGFloat
    
    var selectorColor: UIColor
    var selectorHeight: CGFloat
}


class TabsScrollView: UIScrollView, UIScrollViewDelegate {
    var appearance: TabsScrollViewAppearance! {
        didSet {
            draw()
        }
    }

    let sliderHeight: CGFloat = 44
    
    var tabs: [TabItem]!
    
    var selector: UIView!
    
    var tabButtons: [UIButton] = []
    
    init(width: CGFloat, tabs: [TabItem]) {
        super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
        self.tabs = tabs
        
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        
        appearance = TabsScrollViewAppearance(
            backgroundColor: UIColor.redColor(),
            font: UIFont.systemFontOfSize(17),
            selectedFont: UIFont.systemFontOfSize(17),
            textColor: UIColor.whiteColor(),
            selectedTextColor: UIColor.whiteColor(),
            outerPadding: 10,
            innerPadding: 10,
            selectorColor: UIColor.whiteColor(),
            selectorHeight: 4
        )
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func draw() {
        // clean
        
        if tabButtons.count > 0 {
            for button in tabButtons {
                
                button.removeFromSuperview()
                
                if selector != nil {
                    selector.removeFromSuperview()
                    selector = nil
                }
            }
        }
        
        tabButtons = []
        
        backgroundColor = appearance.backgroundColor
        
        var buttonTag = 0
        var currentX = appearance.outerPadding
        
        for tab in tabs {
            let button = buttonBy(tab)
            button.frame.origin.x = currentX
            button.center.y = frame.size.height/2
            button.tag = buttonTag++
            
            addSubview(button)
            tabButtons.append(button)
            currentX += button.frame.size.width + appearance.outerPadding
        }

        let selectorH = appearance.selectorHeight
        selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: 100, height: selectorH))
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        
        contentSize = CGSize (width: currentX, height: frame.size.height)
    }
    
    func buttonBy(tab: TabItem) -> UIButton {
        let button = UIButton()
        button.frame.size.height = 20
        button.frame.size.width += appearance.innerPadding * 2
        button.setImage(tab.imageNormal, forState: UIControlState.Normal)
        button.setImage(tab.imageActive, forState: UIControlState.Highlighted)
        
        return button
    }
}












