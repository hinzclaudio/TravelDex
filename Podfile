platform :ios, '15.0'
plugin 'cocoapods-acknowledgements', :targets => ['TravelWeather'], :settings_bundle => true

target 'TravelWeather' do
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

  target 'TravelWeatherTests' do
    inherit! :search_paths

    pod 'RxBlocking'
    pod 'RxTest'

  end

  target 'TravelWeatherUITests' do
  end

end


post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-TravelWeather-metadata.plist', 'Settings.bundle/Pods-TravelWeather-settings-metadata.plist', :remove_destination => true)
end
