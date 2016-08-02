//
//  GPSOAuth.swift
//  pgorate
//
//  Created by Rowell Heria on 02/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import Alamofire

class GPSOAuth {
    static let sharedInstance = GPSOAuth()
    
    var email: String!
    var password: String!
    var accessToken: String?
    var token: String?
    var expires: Int?
    var loggedIn: Bool = false
    
    private func parseKeyValues(body:String) -> Dictionary<String, String> {
        var obj = [String:String]()
        let bodySplit = body.componentsSeparatedByString("\n")
        for values in bodySplit {
            var keysValues = values.componentsSeparatedByString("=")
            obj[keysValues[0]] = keysValues[1]
        }
        return obj;
    }
    
    func getTicket(email: String, password: String) {
        GPSOAuth.sharedInstance.email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let params = [
            "accountType": "HOSTED_OR_GOOGLE",
            "Email": GPSOAuth.sharedInstance.email,
            "has_permission": "1",
            "add_account": "1",
            "Passwd": password.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
            "service": "ac2dm",
            "source": "android",
            "androidId": "9774d56d682e549c",
            "device_country": "us",
            "operatorCountry": "us",
            "lang": "en",
            "sdk_version": "17"
        ]
        
        Alamofire.request(.POST, Endpoint.GoogleLogin, parameters: params, headers: headers, encoding: .URLEncodedInURL)
        .responseJSON { (response) in
            let responseString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//            print(responseString)
            let googleDict = self.parseKeyValues(responseString! as String)
            
            if googleDict["Token"] != nil {
                self.loginOAuth(googleDict["Token"]!)
            } else {
                Auth.sharedInstance.delegate?.didNotReceiveAuth()
            }
        }
    }
    
    func loginOAuth(token: String) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let params = [
            "accountType": "HOSTED_OR_GOOGLE",
            "Email": GPSOAuth.sharedInstance.email,
            "EncryptedPasswd": token,
            "has_permission": "1",
            "add_account": "1",
            "source": "android",
            "service": "audience:server:client_id:848232511240-7so421jotr2609rmqakceuu1luuq0ptb.apps.googleusercontent.com",
            "androidId": "9774d56d682e549c",
            "app": "com.nianticlabs.pokemongo",
            "client_sig": "321187995bc7cdc2b5fc91b11a96e2baa8602c62",
            "device_country": "us",
            "operatorCountry": "us",
            "lang": "en",
            "sdk_version": "17"
        ]
        
        Alamofire.request(.POST, Endpoint.GoogleLogin, parameters: params, headers: headers, encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                let responseString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                let googleDict = self.parseKeyValues(responseString! as String)
                
                if googleDict["Auth"] != nil {
                    GPSOAuth.sharedInstance.accessToken = googleDict["Auth"]!
                    GPSOAuth.sharedInstance.expires = Int(googleDict["Expiry"]!)!
                    Auth.sharedInstance.loggedIn = true
                    Auth.sharedInstance.delegate?.didReceiveAuth()
                } else {
                    Auth.sharedInstance.delegate?.didNotReceiveAuth()
                }
        }
    }
}
