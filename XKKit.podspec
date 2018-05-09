#
#  Be sure to run `pod spec lint XKKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

   s.name         = "XKKit"
   s.version      = "0.0.3"
   s.summary      = "静态库XKKit - 消息中心、GCD方法封装"
   s.homepage     = "https://github.com/RyanMans/XKKit"
   s.license          = { :type => 'MIT', :file => 'LICENSE' }
   s.author           = { 'ALLen、LAS' => '1696186412@qq.com' }
   s.source           = { :git => 'https://github.com/RyanMans/XKKit.git', :tag => s.version.to_s }
   s.source_files = 'XKKit/Classes/**/*'
#s.ios.vendored_frameworks = 'Products/*.framework'
   s.ios.deployment_target = '8.0'
   s.ios.vendored_frameworks = 'XKKit/Classes/XKKit.framework'



end
