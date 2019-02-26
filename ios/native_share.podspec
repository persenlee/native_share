#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'native_share'
  s.version          = '0.0.1'
  s.summary          = 'native share plugin for flutter'
  s.description      = <<-DESC
native share plugin for flutter project.
                       DESC
  s.homepage         = 'https://github.com/persenlee/native_share'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'persenlee' => 'persenlee90@gmail.com' }
  s.source        = { :git => "https://github.com/persenlee/native_share.git", :tag => "1.0.0" }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MBProgressHUD'
  s.dependency 'WTAuthorizationTool'
  s.resources  = 'native_share.bundle',
  s.ios.deployment_target = '8.0'
end

