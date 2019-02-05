//
//  PopcornTabBarItemView.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum PopcornTabBarItemViewState {
  case none
  case normal
  case selected
}

protocol PopcornTabBarItemViewDelegate: class {
  func didSelectedTabBarItem(_ item: PopcornTabBarItem, atIndex index: Int)
}

class PopcornTabBarItemView: UIView {
  private var item: PopcornTabBarItem!
  private var index: Int!
  weak var delegate: PopcornTabBarItemViewDelegate?
  private let disposeBag = DisposeBag()
  var curState = BehaviorRelay<PopcornTabBarItemViewState>(value: .none)
  
  init(item: PopcornTabBarItem, index: Int, frame: CGRect) {
    self.item = item
    self.index = index
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setup() {
    let button = UIButton(type: .custom)
    button.frame = self.bounds
    button.backgroundColor = .clear
    button.setTitle(item.getTitle(), for: UIControl.State.normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    self.addSubview(button)
    
    self.layer.cornerRadius = 6
    self.backgroundColor = .clear
    curState.accept(.normal)
    
    //bind
    curState.asObservable().distinctUntilChanged().subscribe(onNext: { [weak self] state in
      guard let self = self else {return}
      switch state {
      case .normal, .none:
        button.setTitleColor(UIColor(RGBA: [101, 101, 137, 100]), for: UIControl.State.normal)
        self.backgroundColor = .white
      case .selected:
        button.setTitleColor(.white, for: UIControl.State.normal)
        self.backgroundColor = UIColor(RGBA: [229, 57, 53, 100])
        self.delegate?.didSelectedTabBarItem(self.item, atIndex: self.index)
      }
    }).disposed(by: disposeBag)
    
    button.rx.tap.asObservable().subscribe(onNext: {  [weak self] _ in
      guard let self = self else {return}
      self.curState.accept(.selected)
    }).disposed(by: disposeBag)
  }
}
