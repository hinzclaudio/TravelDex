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

  target 'TravelDexTests' do
    inherit! :search_paths

    pod 'RxBlocking'
    pod 'RxTest'

  end

  target 'TravelDexUITests' do
  end

end


#post_install do | installer |
#  require 'fileutils'
#  FileUtils.cp_r('Pods/Pods-TravelDex-metadata.plist', 'Settings.bundle/Pods-TravelDex-settings-metadata.plist', :remove_destination => true)
#end
