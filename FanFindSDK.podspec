Pod::Spec.new do |spec|
    spec.name         = "FanFindSDK"
    spec.version      = "2.1.12-next"
    spec.summary      = "FanFind is a tool for helping fands find each other anonymously in real time."

    spec.description  = <<-DESC
    This cocoapods library helps you easily integrate the FanFind API in your application.
                    DESC

    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    spec.homepage     = "https://www.turnoutt.com"
    spec.license      = "MIT"
    spec.author             = { "Chris Woolum" => "chris@turnoutt.com" }

    spec.source_files = "FanFindSDK/**/*.{swift}"


    spec.resources = "FanFindSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

    spec.ios.deployment_target = "12.1"
    spec.swift_versions = ['5.0', '5.1', '5.2', '5.3']

    spec.source        = { :git => "https://github.com/Turnoutt/FanFind-iOS.git", 
        :tag => "#{spec.version}" }



end
