# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def all_pods
    pod 'SwiftLint'
    pod 'Firebase/Firestore'
    pod 'Firebase/Auth'
    pod 'SnapKit', '~> 5.0.1'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'lottie-ios'
    pod 'IQKeyboardManagerSwift'
end

target 'juju' do
    all_pods
end

target 'jujuTests' do
    all_pods
    pod 'Nimble-Snapshots'
    pod 'Quick'
    pod 'Nimble'
end
