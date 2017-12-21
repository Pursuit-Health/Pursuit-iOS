# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pursuit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'SkyFloatingLabelTextField'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              end
          end
      end
  end
  
  use_frameworks!
  pod 'KVNProgress'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'HMSegmentedControl'
  pod 'ESTabBarController-swift'
  pod 'SwipeCellKit'
  
  pod 'AlamofireObjectMapper', '~> 5.0'
  pod 'SDWebImage', '~> 4.1'
  pod 'TPKeyboardAvoiding', '~> 1.3'
  pod 'SVProgressHUD', '~> 2.2'
  pod 'pop', '~> 1.0'
  pod 'JTAppleCalendar', '~> 7.0'
  pod 'KeychainAccess', '~> 3.0'
  pod 'DeepLinkKit', '~> 1.4'
  pod 'RHDisplayLinkStepper', '~> 1.0'
  pod 'SHTextFieldBlocks', '~> 1.1'
  pod 'SwiftDate', '~> 4.5'
  pod 'SDWebImage', '~> 4.1'
  pod 'HTTPStatusCodes', '~> 3.1'
  pod 'TPKeyboardAvoiding', '~> 1.3'
  #pod 'PIDatePicker', '~> 0.1.3'
  
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'GrowingTextView', '~> 0.5.3'
  pod 'IQKeyboardManagerSwift', '~> 5.0'
  pod 'KeyboardWrapper', '~> 4.0'
  
  
end
