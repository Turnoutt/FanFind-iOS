Pod::Spec.new do |spec|
    spec.name         = "FanFind"
    spec.version      = "0.1.0"
    spec.summary      = "FanFind is a tool for helping fans find each other anonymously in real time."

    spec.description  = <<-DESC
    This cocoapods library helps you easily integrate the FanFind API in your application.
                    DESC

    spec.homepage     = "https://www.turnoutt.com"
    spec.license      = "MIT"
    spec.author             = { "Chris Woolum" => "chris@turnoutt.com" }

    spec.ios.deployment_target = "12.1"
    spec.swift_version = "5.0"

    spec.source        = { :http => "https://github.com/Turnoutt/FanFind-iOS/archive/0.1.0.tar.gz" }

    spec.source_files = "build/universal/FanFindSDK.framework/Headers/*.h"
    spec.public_header_files = "build/universal/FanFindSDK.framework/Headers/*.h"
    spec.vendored_frameworks = "build/universal/FanFindSDK.framework"
    spec.platform = :ios, "9.0"
   
end
