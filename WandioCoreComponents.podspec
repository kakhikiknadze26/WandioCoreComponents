Pod::Spec.new do |spec|

  spec.name         = "WandioCoreComponents"
  spec.version      = "0.0.4"
  spec.summary      = "Reusable components in Swift."

  spec.description  = <<-DESC
  Collection of reusable components like shadowed views with corner radius, visual effects with intensity value, some helper classes and more.
                   DESC

  spec.homepage     = "https://github.com/kakhikiknadze26/WandioCoreComponents"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Kakhi Kiknadze" => "kakhi.kiknadze@wandio.com" }
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"
  spec.source       = { :git => "https://github.com/kakhikiknadze26/WandioCoreComponents.git", :tag => "#{spec.version}" }
  spec.source_files  = "WandioCoreComponents/**/*.{h,m,swift}"

end
