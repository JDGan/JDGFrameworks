#
# Be sure to run `pod lib lint JDGFrameworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JDGFrameworks'
  s.version          = '0.0.1'
  s.summary          = '程序员JDG的框架仓库（Swift）'
  s.description      = <<-DESC
欢迎来到程序员JDG的框架仓库，目前仅包含项目的基本框架。
                       DESC
  s.homepage         = 'https://github.com/jessiegan1987@163.com/JDGFrameworks'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jessiegan1987@163.com' => 'jessiegan1987@163.com' }
  s.source           = { :git => 'https://github.com/jessiegan1987@163.com/JDGFrameworks.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'

  s.ios.deployment_target = '9.0'

  s.subspec 'Base' do |sub|
      sub.source_files = 'JDGFrameworks/Classes/Base/**/*.swift'
      sub.public_header_files = 'JDGFrameworks/Classes/Base/**/*.h'
  end
  
  s.requires_arc = true
end
