//
//  PhotoPickerViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 13.08.22.
//

import Foundation
import RxSwift
import PhotosUI



protocol PhotoPickerViewModelType: PHPickerViewControllerDelegate {
    var configuration: PHPickerConfiguration { get }
}
