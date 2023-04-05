source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

inhibit_all_warnings!

target 'Base' do

  pod 'XCoordinator'
  
  pod 'MMKV'
  pod 'CleanJSON'
  pod 'CodableWrapper'

  # SDK

end


post_install do |installer|

  installer.pods_project.targets.each do |target|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = "NO"
    end

    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13'
      end
    end

    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end

  installer.pods_project.targets.each do |target|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end

    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

  installer.target_installation_results.pod_target_installation_results
           .each do |pod_name, target_installation_result|
    target_installation_result.resource_bundle_targets.each do |resource_bundle_target|
      resource_bundle_target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end

