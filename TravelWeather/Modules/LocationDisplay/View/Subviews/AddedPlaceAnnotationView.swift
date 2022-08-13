//
//  AddedPlaceAnnotationView.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 13.08.22.
//

import UIKit
import MapKit



class AddedPlaceAnnotationView: MKAnnotationView {
    
    // MARK: - Views
    private let pinView = UIImageView()
    
    private let calloutContainer = UIView()
    private let imgContainer = UIView()
    private let imgView = UIImageView()
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    private func setup() {
        addViews()
        configureViews()
        setAutoLayout()
    }
    
    private func addViews() {
        addSubview(pinView)
        calloutContainer.addSubview(imgContainer)
        imgContainer.addSubview(imgView)
    }
    
    private func configureViews() {
        pinView.isUserInteractionEnabled = true
        pinView.image = SFSymbol.filledMappin.image
        pinView.contentMode = .scaleAspectFit
        pinView.frame = CGRect(
            origin: .init(x: 0 - Sizes.mapPinSize.width / 2, y: 0 - Sizes.mapPinSize.height),
            size: Sizes.mapPinSize
        )
        
        calloutContainer.frame = CGRect(
            origin: .zero,
            size: Sizes.smallImgPreview
        )
        
        imgContainer.roundCorners(radius: Sizes.halfDefMargin)
        imgContainer.layer.borderColor = Colors.black.cgColor
        imgContainer.layer.borderWidth = 2
        
        imgView.tintColor = Colors.black
        imgView.contentMode = .scaleAspectFit
        
        rightCalloutAccessoryView = calloutContainer
        canShowCallout = true
    }
    
    private func setAutoLayout() {
        imgContainer.autoPinEdge(.top, to: .top, of: calloutContainer, withOffset: Sizes.halfDefMargin)
        imgContainer.autoPinEdge(.left, to: .left, of: calloutContainer, withOffset: Sizes.halfDefMargin)
        imgContainer.autoPinEdge(.right, to: .right, of: calloutContainer, withOffset: -Sizes.halfDefMargin)
        imgContainer.autoPinEdge(.bottom, to: .bottom, of: calloutContainer, withOffset: -Sizes.halfDefMargin)
        
        imgView.autoPinEdge(.top, to: .top, of: imgContainer, withOffset: Sizes.halfDefMargin)
        imgView.autoPinEdge(.left, to: .left, of: imgContainer, withOffset: Sizes.halfDefMargin)
        imgView.autoPinEdge(.right, to: .right, of: imgContainer, withOffset: -Sizes.halfDefMargin)
        imgView.autoPinEdge(.bottom, to: .bottom, of: imgContainer, withOffset: -Sizes.halfDefMargin)
    }
    
    
    func configure(for annotation: MKAnnotation) {
        if let annotation = annotation as? LocationDisplayAnnotation {
            imgView.image = annotation.img ?? SFSymbol.camera.image
            pinView.tintColor = annotation.highlighted ? Colors.orange : Colors.darkRed
            
        } else {
            assertionFailure("Someting's wrong!")
        }
    }
    
}
