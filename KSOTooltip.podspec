#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOTooltip'
  s.version          = '1.3.2'
  s.summary          = 'KSOTooltip is a iOS framework for displaying informational tooltips.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSOTooltip is an `iOS` framework for displaying informational tooltips modally. It can display instances of `NSString` and `NSAttributedString`, with or without an arrow and with an optional accessory view displayed below the text.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOTooltip'
  s.screenshots      = ['https://github.com/Kosoku/KSOTooltip/raw/master/screenshots/iOS-1.png','https://github.com/Kosoku/KSOTooltip/raw/master/screenshots/iOS-2.png','https://github.com/Kosoku/KSOTooltip/raw/master/screenshots/iOS-3.png','https://github.com/Kosoku/KSOTooltip/raw/master/screenshots/iOS-4.png']
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOTooltip.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.requires_arc = true

  s.source_files = 'KSOTooltip/**/*.{h,m}'
  s.exclude_files = 'KSOTooltip/KSOTooltip-Info.h'
  s.private_header_files = 'KSOTooltip/Private/*.h'
  
  s.resource_bundles = {
    'KSOTooltip' => ['KSOTooltip/**/*.{xcassets,lproj}']
  }
  
  s.dependency 'Agamotto'
  s.dependency 'Ditko'
end
