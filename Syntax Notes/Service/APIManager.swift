//
//  APIManager.swift
//  Syntax Notes
//
//  Created by Sunny on 09/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD


class APIManager{
    static let shared = APIManager()
    private init(){
        
    }
    // Get API without params
    func getDataFromGetMethod(urlStr:String, loader:Int,viewcontroller:UIViewController, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if loader == 1{
            [MBProgressHUD .showAdded(to: viewcontroller.view, animated: true)]
        }
        let apiURL = BASE_URL
        Alamofire.request(apiURL).responseJSON { response in
            switch response.result{
            case.success(let data):
                [MBProgressHUD .hide(for: viewcontroller.view, animated: true)]
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                [MBProgressHUD .hide(for: viewcontroller.view, animated: true)]
                print("Failure:",error)
                failure(error)
            }
        }
    }
    
    // Get API with one param
    func getResponseGetMethodOneParam(urlStr:String, viewController:UIViewController,paramvalue:String,paramname:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        if loadercheck == 1{
            [MBProgressHUD .showAdded(to: viewController.view, animated: true)]
        }
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param = URLQueryItem(name:paramname, value: paramvalue)
        
        components?.queryItems = [param]
        
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                [MBProgressHUD .hide(for: viewController.view, animated: true)]
                
                let getresponse = JSON(data)
                [MBProgressHUD .hide(for: viewController.view, animated: true)]
                onCompletion(getresponse)
                
            case.failure(let error):
                [MBProgressHUD .hide(for: viewController.view, animated: true)]
                
                print("Failure:",error)
                failure(error)
            }
        }
    }
    
    // Get API with two params
    func getResponseGetMethodTwoParams(urlStr:String, viewController:UIViewController,paramvalue1:String,paramname1:String,paramvalue2:String,paramname2:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param1 = URLQueryItem(name:paramname1, value: paramvalue1)
        let param2 = URLQueryItem(name:paramname2, value: paramvalue2)
        
        components?.queryItems = [param1,param2]
        
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                
                print("Failure:",error)
                failure(error)
                
            }
        }
    }
    
    // Get API with three params
    func getResponseGetMethodThreeParams(urlStr:String, viewController:UIViewController,paramvalue1:String,paramname1:String,paramvalue2:String,paramname2:String,paramvalue3:String,paramname3:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param1 = URLQueryItem(name:paramname1, value: paramvalue1)
        let param2 = URLQueryItem(name:paramname2, value: paramvalue2)
        let param3 = URLQueryItem(name: paramname3, value: paramvalue3)
        
        components?.queryItems = [param1,param2,param3]
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                
                print("Failure:",error)
                failure(error)
                
            }
        }
    }
    
    // Get API with four params
    func getResponseGetMethodFourParams(urlStr:String, viewController:UIViewController,paramvalue1:String,paramname1:String,paramvalue2:String,paramname2:String,paramvalue3:String,paramname3:String,paramvalue4:String,paramname4:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param1 = URLQueryItem(name:paramname1, value: paramvalue1)
        let param2 = URLQueryItem(name:paramname2, value: paramvalue2)
        let param3 = URLQueryItem(name: paramname3, value: paramvalue3)
        let param4 = URLQueryItem(name: paramname4, value: paramvalue4)
        
        components?.queryItems = [param1,param2,param3,param4]
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                print("Failure:",error)
                failure(error)
            }
        }
    }
    
    // Get API with five params
    func getResponseGetMethodFiveParams(urlStr:String, viewController:UIViewController,paramvalue1:String,paramname1:String,paramvalue2:String,paramname2:String,paramvalue3:String,paramname3:String,paramvalue4:String,paramname4:String,paramvalue5:String,paramname5:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param1 = URLQueryItem(name:paramname1, value: paramvalue1)
        let param2 = URLQueryItem(name:paramname2, value: paramvalue2)
        let param3 = URLQueryItem(name: paramname3, value: paramvalue3)
        let param4 = URLQueryItem(name: paramname4, value: paramvalue4)
        let param5 = URLQueryItem(name: paramname5, value: paramvalue5)
        
        components?.queryItems = [param1,param2,param3,param4,param5]
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                
                print("Failure:",error)
                failure(error)
            }
        }
    }
    
    // Get API with six params
    func getResponseGetMethodSixParams(urlStr:String, viewController:UIViewController,paramvalue1:String,paramname1:String,paramvalue2:String,paramname2:String,paramvalue3:String,paramname3:String,paramvalue4:String,paramname4:String,paramvalue5:String,paramname5:String,paramvalue6:String,paramname6:String,loadercheck:Int, onCompletion:@escaping (JSON) -> Void, failure:@escaping (Error)->Void){
        
        let apiURL = BASE_URL+urlStr
        var components = URLComponents(string: apiURL)
        let param1 = URLQueryItem(name:paramname1, value: paramvalue1)
        let param2 = URLQueryItem(name:paramname2, value: paramvalue2)
        let param3 = URLQueryItem(name: paramname3, value: paramvalue3)
        let param4 = URLQueryItem(name: paramname4, value: paramvalue4)
        let param5 = URLQueryItem(name: paramname5, value: paramvalue5)
        let param6 = URLQueryItem(name: paramname6, value: paramvalue6)
        
        components?.queryItems = [param1,param2,param3,param4,param5,param6]
        Alamofire.request((components?.url)!).responseJSON { response in
            switch response.result{
            case.success(let data):
                let getresponse = JSON(data)
                onCompletion(getresponse)
                
            case.failure(let error):
                print("Failure:",error)
                failure(error)
            }
        }
    }
    
    // Post API
    func getResponseFromPost(ParaMeters:[String:Any], ViewController:UIViewController, loaderchek:Int, onCompletion:@escaping (JSON) ->Void, Failure:@escaping (Error) ->Void) {
        if loaderchek == 1{
            MBProgressHUD .showAdded(to: ViewController.view, animated: true)
        }
        let ApiURL = BASE_URL
        Alamofire.request(ApiURL, method: .post, parameters: ParaMeters, encoding:JSONEncoding.prettyPrinted, headers: nil).responseJSON { response in
            switch (response.result){
            case.success(let data):
                let getresponse = JSON(data)
                MBProgressHUD .hide(for:ViewController.view , animated: true)
                onCompletion(getresponse)
                
            case.failure(let error):
                MBProgressHUD .hide(for:ViewController.view , animated: true)
                Failure(error)
            }
        }
    }
    
    // Upload Image By Multi-Parts
    func uploadImageToServer(urlStr:String, paraMeters:Dictionary<String, Any>, imageToUpload:UIImage,  viewController:UIViewController, onCompletion: @escaping (JSON) ->Void, failure: @escaping (Error) ->Void) {
        let apiURL = BASE_URL+urlStr
        let para : Parameters = paraMeters
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in para {
                
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageToUpload.jpegData(compressionQuality: 1){
                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: apiURL, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response.request as Any)
                    print(response.response as Any)
                    print(response.data as Any)
                    print(response.result)
                    
                    if let JSONN = response.result.value {
                        print("JSON: \(JSONN)")
                        let getresponse = JSON(JSONN)
                        onCompletion(getresponse)
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error)
            }
        }
    }
}
