//
//  MockPhotoPickerViewModel.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 11.09.22.
//

import PhotosUI
import RxRelay
@testable import TravelDex



class MockPhotoPickerViewModel: PhotoPickerViewModelType {
    
    let configuration = PHPickerConfiguration()
    
    var pickedResults = BehaviorRelay<[PHPickerResult]?>(value: nil)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        pickedResults.accept(results)
    }
    
}
