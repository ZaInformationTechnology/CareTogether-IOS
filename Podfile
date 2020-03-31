# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CareTogether' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

def share_pod
  pod 'SkyFloatingLabelTextField'
  pod 'ObjectMapper', '~> 3.4'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'DropDown', '2.3.4'
  pod 'Moya/RxSwift', '~> 14.0.0-beta.6'
  pod 'EFCountingLabel'
  pod 'CRRefresh'
  pod 'JGProgressHUD'
  pod 'StepIndicator', '~> 1.0.8'
  pod 'TagListView', '~> 1.0'
	pod 'IQKeyboardManager'
	pod 'SwipeCellKit'
pod 'SKCountryPicker'
pod 'SKPhotoBrowser'
pod 'SwiftHEXColors'
pod 'ImageSlideshow', '~> 1.8.3'
pod "ImageSlideshow/Kingfisher"
#pod 'SwiftDataTables'
end


  # Pods for CareTogether
    inherit! :search_paths

	share_pod

  target 'CareTogetherTests' do
    inherit! :search_paths
    # Pods for testing
	share_pod
  end

  target 'CareTogetherUITests' do
    # Pods for testing
share_pod
  end

end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
