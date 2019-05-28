//
//  HttpHelp.swift
//  Fuelpak FP3
//
//  Created by Mike Saradeth on 1/7/19.
//  Copyright © 2019 Vance & Hines. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum ApiResult {
    case sucess
    case error
}


class HttpHelp: NSObject {
    
    class func request(_ url: URLConvertible, method: HTTPMethod, params: Parameters?, isDealerServer: Bool = false, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        let httpHelper = HttpHelp()
        httpHelper.request(url, method: method, params: params, isDealerServer: isDealerServer, success: { (response) in
            success(response)
        }) { (error) in
            failure(error)
        }
    }
    

    func request(_ url: URLConvertible, method: HTTPMethod, params: Parameters?, isDealerServer: Bool = false, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(url, method: method, parameters: params, headers: nil ).responseJSON { response in
            switch response.result {
            case .success:
                //                let resJSON = JSON(response.result.value!)
                //                print(resJSON)
                success(response)
                
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    deinit {
        print("HttpHelp func deinit() debug")
    }
    
}


