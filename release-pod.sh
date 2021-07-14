
version=$1
path=$2

echo "Path is $PWD"

cat > FanFind.podspec <<-EOF
Pod::Spec.new do |spec|
    spec.name         = "FanFind"
    spec.version      = "$version"
    spec.summary      = "FanFind is a tool for helping fands find each other anonymously in real time."

    spec.description  = <<-DESC
    This cocoapods library helps you easily integrate the FanFind API in your application.
                    DESC

    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    spec.homepage     = "https://www.turnoutt.com"
    spec.license      = "MIT"
    spec.author             = { "Chris Woolum" => "chris@turnoutt.com" }

    spec.ios.deployment_target = "12.1"
    spec.swift_versions = ['5.0', '5.1', '5.2', '5.3']

    spec.source        = { :http => "https://github.com/Turnoutt/FanFind-iOS/releases/download/$version/FanFind-iOS-$version.zip" }

    spec.vendored_frameworks = "build/universal/FanFindSDK.framework"

end
EOF

cat FanFind.podspec

pod trunk push FanFind.podspec --allow-warnings --verbose
