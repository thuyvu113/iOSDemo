//
//  PopcornTabBar.swift
//  SwiftDemoProject
//
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PopcornTabBarItem {
  func getTitle() -> String
}

class PopcornTabBarView: UIView {
  private var scrollView: UIScrollView!
  private var items: [PopcornTabBarItem] = []
  private var itemViews: [PopcornTabBarItemView] = []
  var selectedGenre = BehaviorRelay<Genre?>(value: nil)
  var selectedIndex = -1
  
  func buildTab(items: [PopcornTabBarItem]) {
    self.items = items
    
    scrollView = UIScrollView(frame: self.bounds)
    scrollView.backgroundColor = .clear
    scrollView.showsHorizontalScrollIndicator = false
    self.addSubview(scrollView)

    
    var lastX: CGFloat = 18
    for (index, item) in items.enumerated() {
      let frame = CGRect(x: lastX, y: 0, width: 100, height: self.bounds.size.height)
      let itemView = PopcornTabBarItemView(item: item, index: index, frame: frame)
      itemView.delegate = self
      scrollView.addSubview(itemView)
      itemViews.append(itemView)
      
      lastX += frame.size.width + 18
    }
    
    scrollView.contentSize = CGSize(width: lastX, height: self.bounds.size.height)
    
    itemViews[0].curState.accept(.selected)
  }
}

extension PopcornTabBarView: PopcornTabBarItemViewDelegate {
  func didSelectedTabBarItem(_ item: PopcornTabBarItem, atIndex index: Int) {
    if selectedIndex != index {
      if selectedIndex >= 0 {
        itemViews[selectedIndex].curState.accept(.normal)
      }
      selectedIndex = index
      selectedGenre.accept(items[selectedIndex] as? Genre)
      
      if selectedIndex != 0 && selectedIndex != itemViews.count - 1 {
        let frame = itemViews[selectedIndex].frame
        let offset = frame.origin.x - (self.frame.size.width / 2 - frame.size.width / 2)
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
      }
    }
  }
}
