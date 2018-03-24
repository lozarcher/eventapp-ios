# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'Surbiton Food Festival'

def available_pods
    source 'https://github.com/CocoaPods/Specs.git'
    source 'https://github.com/mwaterfall/MWPhotoBrowser.git'
    
    pod 'MWPhotoBrowser',  '~> 2.1.2'
    pod 'KILabel'
    pod 'UITableView+FDTemplateLayoutCell', '~> 1.6'
    pod 'FontAwesomeKit'
end

target 'Surbiton Food Festival' do
	available_pods
end

target 'IYAF' do
    available_pods
end
