Pod::Spec.new do |s|
  s.name = 'Fattmerchant'
  s.version = '1.4.4'
  s.license = { :type => 'Apache License, Version 2.0', :text => "© #{ Date.today.year } Fattmerchant, inc" }
  s.summary = 'Fattmerchant iOS SDK'
  s.homepage = 'https://github.com/fattmerchantorg/Fattmerchant-iOS-SDK'
  s.authors = { 'Fattmerchant' => 'techteam@fattmerchant.com' }
  s.source = { :git => 'https://github.com/fattmerchantorg/Fattmerchant-iOS-SDK.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.swift_versions = ['4.0', '4.2', '5.2']  
  s.source_files = "fattmerchant-ios-sdk/**/*.{h,m,swift}"

  s.frameworks = 'UIKit', 'AVFoundation', 'MediaPlayer', 'CoreAudio', 'ExternalAccessory', 'CoreBluetooth', 'AudioToolbox'

  s.vendored_libraries = 'fattmerchant-ios-sdk/Cardpresent/ChipDnaMobile/libChipDnaMobileAPI.a', 'fattmerchant-ios-sdk/Cardpresent/ChipDnaMobile/libsqlcipher-4.0.1.a', 'fattmerchant-ios-sdk/Cardpresent/ChipDnaMobile/libCardEaseXml.a', 'fattmerchant-ios-sdk/Cardpresent/ChipDnaMobile/libLumberjack.a'
 
  s.pod_target_xcconfig = { 
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-lz'
  }

end
