#  Be sure to run `pod spec lint FlatNetworkClient.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FlatNetworkClient"
  s.version      = "1.1.0"
  s.summary      = "Swifty wrapper around URLSession"

  s.description  = <<-DESC
                    A swifty wrapper around URLSession. Built for ease and testability.
                   DESC

  s.homepage     = "https://github.com/flatcircle/FlatNetworkClient"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Flat Circle" => "info@flatcircle.io" }
  s.platform     = :ios
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/flatcircle/FlatNetworkClient.git", :tag => "#{s.version}" }
  s.source_files  = "FlatNetworkClient/*"

end
