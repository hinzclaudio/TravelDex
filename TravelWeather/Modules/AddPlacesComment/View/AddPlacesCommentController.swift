//
//  AddPlacesCommentController.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 24.08.22.
//

import UIKit
import RxSwift
import RxCocoa



class AddPlacesCommentController: ScrollableVStackController {
    
    let viewModel: AddPlacesCommentViewModelType
    let bag = DisposeBag()
    
    
    // MARK: - Views
    let doneButton = UIBarButtonItem(systemItem: .done)
    let textView = TitledTextView()
    
    
    
    init(viewModel: AddPlacesCommentViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    // MARK: - Setup Funcs
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
        setupBinding()
    }
    
    private func addViews() {
        view.backgroundColor = Colors.veryDark
        navigationItem.rightBarButtonItem = doneButton
        contentStack.addArrangedSubview(textView)
    }
    
    private func configureViews() {
        textView.descrLabel.text = "What made this place so special?"
    }
    
    private func setAutoLayout() {
        textView.autoMatch(.width, to: .width, of: contentStack)
    }
    
    private func setupBinding() {
        viewModel.addedPlace
            .map { String(format: "Enter a Comment for %@", $0.location.name) }
            .drive(textView.titleLabel.rx.text)
            .disposed(by: bag)
        viewModel.addedPlace
            .map { $0.visitedPlace.text }
            .drive(textView.textView.rx.text)
            .disposed(by: bag)
        textView.textView.rx.text
            .bind(to: viewModel.comment)
            .disposed(by: bag)
        viewModel.confirm(doneButton.rx.tap.asObservable())
            .disposed(by: bag)
    }
    
}
