suffix = '-dev'   # Dev mode
#suffix = ''       # Release

Pod::Spec.new do |s|
  
  s.name             = 'PlayKitVR'
  s.version          = '1.0.3' + suffix
  s.summary          = 'PlayKitVR -- VR framework for iOS'
  s.homepage         = 'https://github.com/kaltura/playkit-ios-vr'
  s.license          = { :type => 'AGPLv3', :file => 'LICENSE' }
  s.author           = { 'Kaltura' => 'community@kaltura.com' }
  s.source           = { :git => 'https://github.com/kaltura/playkit-ios-vr.git', :tag => 'v' + s.version.to_s }
  s.swift_version    = '4.2'

  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*'

  s.dependency 'PlayKit/Core'
  
end

# To add playkit VR as dependecy use: s.dependency 'PlayKitVR', 'version_number'
