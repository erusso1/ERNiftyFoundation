#
# Be sure to run `pod lib lint ERNiftyFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ERNiftyFoundation'
  s.version          = '2.2.2'
  s.summary          = 'A library of dependencies, models, and managers useful to start any iOS project.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A nifty foundation (sort of like a template) for any application that plans on having users, RESTful connectivity, and the most convenient CocoaPods out of the box. So basically every iOS application could use it.'

  s.homepage         = 'https://github.com/erusso1/ERNiftyFoundation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erusso1' => 'ephraim.s.russo@gmail.com' }
  s.source           = { :git => 'https://github.com/erusso1/ERNiftyFoundation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ERNiftyFoundation/Source/**/*'

  # s.resource_bundles = {
  #   'ERNiftyFoundation' => ['ERNiftyFoundation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Alamofire'

  s.dependency 'AlamofireNetworkActivityLogger'

  s.dependency 'ERNiftyExtensions'

  s.dependency 'Unbox'

  s.dependency 'Wrap'

end
