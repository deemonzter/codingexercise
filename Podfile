platform :ios, '9.0'
inhibit_all_warnings!

use_frameworks!

#Using Alamofire (4.7.2)
#Using AlamofireImage (3.3.1)
#Using Nimble (7.1.1)
#Using Quick (1.3.0)
#Using RxAlamofire (4.2.0)
#Using RxCocoa (4.1.2)
#Using RxSwift (4.1.2)
#Installing SVProgressHUD (2.2.5)
#Using SwiftyJSON (4.1.0)

target 'FastDelivery' do
    pod 'RxAlamofire'
    pod 'AlamofireImage'
    pod 'SwiftyJSON'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SVProgressHUD'
end

abstract_target 'Tests' do
    target 'FastDeliveryTests'
    target 'FastDeliveryUITests'
    
    pod 'Quick'
    pod 'Nimble'
    pod 'RxSwift'
    
end
