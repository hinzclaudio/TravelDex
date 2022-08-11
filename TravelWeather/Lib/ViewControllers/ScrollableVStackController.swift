//
//  ScrollableVStackController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import PureLayout



class ScrollableVStackController: UIViewController {
    
    private let scrollView = UIScrollView()
    let contentStack = UIStackView.defaultContentStack()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        addViews()
        setAutoLayout()
    }
    
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
    }
    
    
    private func setAutoLayout() {
        scrollView.autoPinEdge(toSuperviewSafeArea: .top)
        scrollView.autoPinEdge(.left, to: .left, of: view)
        scrollView.autoPinEdge(.right, to: .right, of: view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
        
        contentStack.autoPinEdge(.top, to: .top, of: scrollView)
        contentStack.autoPinEdge(.left, to: .left, of: scrollView)
        contentStack.autoPinEdge(.right, to: .right, of: scrollView)
        contentStack.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: -Sizes.defaultMargin)
        contentStack.autoMatch(.width, to: .width, of: scrollView)
    }
    
}
