#
# Be sure to run `pod lib lint SwiftGraphKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftGraphKit'
  s.version          = '0.2.0'
  s.swift_version    = '4.2'
  s.summary          = 'SwiftGraphKit is a framework to draw scrollable graph on your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftGraphKit is a framework to draw graph on your app. GraphView are scrollable and zoomable, content is automatically redraw to have amazing animation.
                       DESC

  s.homepage         = 'https://github.com/bessonnet/SwiftGraphKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cbessonnet75@gmail.com' => 'cbessonnet75@gmail.com' }
  s.source           = { :git => 'https://github.com/bessonnet/SwiftGraphKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftGraphKit' => ['Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
