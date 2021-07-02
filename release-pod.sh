
version=$1
path=$2

echo "Path is $PWD"

cat > FanFind.podspec <<-EOF
Pod::Spec.new do |spec|
    spec.name         = "FanFind"
    spec.version      = "$version"
    spec.summary      = "FanFind is a tool for helping fands find each other anonymously i real time."

    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    spec.description  = <<-DESC
    This cocoapods library helps you easily integrate the FanFind API in your application.
                    DESC

    spec.homepage     = "https://www.turnoutt.com"
    spec.license      = "MIT"
    spec.author             = { "Chris Woolum" => "chris@turnoutt.com" }

    spec.ios.deployment_target = "12.1"
    spec.swift_version = "4.2"

    spec.source        = { :git => "https://github.com/turnoutt/FanFind-iOS.git" }

    spec.source_files = "${path}FanFind.framework/Headers/*.h"
    spec.public_header_files = "${path}FanFind.framework/Headers/*.h"
    spec.vendored_frameworks = "${path}FanFind.framework"
    spec.platform = :ios, "9.0"

end
EOF

cat FanFind.podspec

pod repo push turnouttpods --allow-warnings
