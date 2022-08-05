platform :ios, '15.0'

target 'TravelWeather' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Sourcery'
  pod 'SwiftGen'
  pod 'CryptoSwift'
  pod 'PureLayout'

  target 'TravelWeatherTests' do
    inherit! :search_paths

    pod 'RxBlocking'
    pod 'RxTest'

  end

  target 'TravelWeatherUITests' do
  end

  plugin 'cocoapods-keys', {
  :project => "TravelWeather",
  :keys => [
    "WeatherAPIKey"
  ]}

end
