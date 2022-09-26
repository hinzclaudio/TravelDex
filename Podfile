platform :ios, '15.0'
use_frameworks!
plugin 'cocoapods-acknowledgements', :targets => ['TravelDex'], :settings_bundle => true

def common_pods
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
end

target 'TravelDex' do
  common_pods

  target 'TravelDexTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end
  
end

target 'MockedTravelDex' do
  common_pods
end
