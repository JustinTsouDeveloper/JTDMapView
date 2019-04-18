Pod::Spec.new do |s|
          #1.
          s.name               = "JTDMapView"
          #2.
          s.version            = "1.0.2"
          #3.  
          s.summary         = "Sort description of 'JTDMapView' framework"
          #4.
          s.homepage        = "https://github.com/JustinTsouDeveloper/JTDMapView.git"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "JustinTsouDeveloper"
          #7.
          s.platform            = :ios, "11.0"
          #8.
          s.source              = { :git => "https://github.com/JustinTsouDeveloper/JTDMapView.git", :tag => s.version.to_s }
          #9.
          s.source_files     = "JTDMapView", "JTDMapView/**/*.{h,m,swift,xib}"
	  #10.
	  s.swift_version = '4.2'
    end