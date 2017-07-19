

Pod::Spec.new do |s|


  s.name         = "CPCBannerView"
  s.version      = "1.0.0"
  s.summary      = "无限轮播图-swift"


  s.homepage     = "https://github.com/CPC-Coder/CPCBannerView"


  s.license      = "MIT"

  s.author             = { "cpc-Coder" => "1914701068@qq.com" }


  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/CPC-Coder/CPCBannerView.git", :tag => s.version }
  s.source_files  = "CPCBannerView", "CPCBannerView/CPCBaseBannerView.swift"

  s.requires_arc = true




s.subspec 'Default' do |ss|

ss.source_files = 'CPCBannerView/Default/*'
ss.dependency 'CPCBannerView/CPCBaseBannerView.swift'

end


s.subspec 'Custom' do |ss|
ss.source_files = 'CPCBannerView/Custom/*'
ss.dependency 'CPCBannerView/CPCBaseBannerView.swift'


end

s.subspec 'TextOnly' do |ss|

ss.source_files = 'CPCBannerView/TextOnly/*'
ss.dependency 'CPCBannerView/CPCBaseBannerView.swift'
end









end
