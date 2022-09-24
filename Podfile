platform :ios, '15.0'
plugin 'cocoapods-acknowledgements', :targets => ['TravelDex'], :settings_bundle => true

target 'TravelDex' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'Sourcery'
  pod 'SwiftGen'
  pod 'PureLayout'
  pod 'CryptoSwift'
  pod 'IQKeyboardManager'
  pod 'DTPhotoViewerController'
  pod 'ZIPFoundation'

  target 'TravelDexTests' do
    inherit! :search_paths

    pod 'RxBlocking'
    pod 'RxTest'

  end

  target 'MockedTravelDex' do
    inherit! :search_paths
  end

end
