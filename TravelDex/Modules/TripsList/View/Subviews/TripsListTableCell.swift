//
//  TripsListCell.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import UIKit



class TripsListTableCell: UITableViewCell {
    
    static let identifier = "TripsListTableViewCell"
    
    // MARK: - Views
    let view = TripCell()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
    }
    
    private func addViews() {
        contentView.addSubview(view)
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setAutoLayout() {
        contentView.backgroundColor = .clear
        view.autoPinEdge(.top, to: .top, of: contentView)
        view.autoPinEdge(.left, to: .left, of: contentView)
        view.autoPinEdge(.right, to: .right, of: contentView)
        view.autoPinEdge(.bottom, to: .bottom, of: contentView)
    }
    
    func configure(for trip: Trip) {
        view.configure(for: trip)
    }
    
}
