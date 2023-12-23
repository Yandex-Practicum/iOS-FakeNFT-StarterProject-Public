platform :ios, '13.0'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

target 'FakeNFT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FakeNFT
  pod 'SwiftGen', '~> 6.0'

  target 'FakeNFTTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FakeNFTUITests' do
    # Pods for testing
  end

end
