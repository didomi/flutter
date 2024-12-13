#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint didomi_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'didomi_sdk'
  s.version          = '2.8.0'
  s.summary          = 'Didomi CMP Plugin.'
  s.homepage         = 'https://github.com/didomi/flutter'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Didomi ' => 'tech@didomi.io' }
  s.source           = { :path => 'git@github.com:didomi/flutter.git', :tag => '2.8.0' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'
  s.dependency       'Didomi-XCFramework', '2.17.0'
  s.platform         = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
