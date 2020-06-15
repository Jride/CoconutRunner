Pod::Spec.new do |s|
  s.name             = "FoundationExtended"
  s.version          = "3.0"
  s.summary          = "Extended Foundation Library"

  s.description      = <<-DESC
Extended Foundation library for iOS and tvOS
                       DESC

  s.homepage         = "https://github.com/ITV"
  s.license          = 'No License'
  s.author           = { "Steve Barnegren" => "steve.barnegren@candyspace.com" }
  s.source           = { :git => "https://github.com/ITV/iOS-FoundationExtended.git", :tag => s.version.to_s }
  s.swift_version = '5.0'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'FoundationExtended/**/*.swift'
end
