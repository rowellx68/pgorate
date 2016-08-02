import Foundation

class gpsoauth {
    static let sharedInstance = gpsoauth()
    var token = "",
        accessToken = "",
        email = ""
    var expiry = 0
    
    func parseKeyValues(body:String) -> Dictionary<String, String> {
        var obj = [String:String]()
        let bodySplit = body.componentsSeparatedByString("\n")
        for values in bodySplit {
            var keysValues = values.componentsSeparatedByString("=")
            obj[keysValues[0]] = keysValues[1]
        }
        return obj;
    }
        
    func getTicket(unescapedEmail: String, password: String) {
        gpsoauth.sharedInstance.email = unescapedEmail.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        self.request("accountType=HOSTED_OR_GOOGLE&Email=" + gpsoauth.sharedInstance.email + "&has_permission=1&add_account=1&Passwd=" + password.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&service=ac2dm&source=android&androidId=9774d56d682e549c&device_country=us&operatorCountry=us&lang=en&sdk_version=17")
    }
    
    func oauth () {
        request("accountType=HOSTED_OR_GOOGLE&Email=" + gpsoauth.sharedInstance.email + "&EncryptedPasswd=" + gpsoauth.sharedInstance.token + "&has_permission=1&service=audience:server:client_id:848232511240-7so421jotr2609rmqakceuu1luuq0ptb.apps.googleusercontent.com&add_account=1&source=android&androidId=9774d56d682e549c&app=com.nianticlabs.pokemongo&client_sig=321187995bc7cdc2b5fc91b11a96e2baa8602c62&device_country=us&operatorCountry=us&lang=en&sdk_version=17")
    }
    
    func request (requestData: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://android.clients.google.com/auth")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.HTTPBody = requestData.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let googleDict = self.parseKeyValues(responseString! as String)
            if googleDict["Token"] != nil {
                gpsoauth.sharedInstance.token = googleDict["Token"]!
                print("Received google token")
                self.oauth()
            } else if googleDict["Auth"] != nil {
                gpsoauth.sharedInstance.accessToken = googleDict["Auth"]!
                gpsoauth.sharedInstance.expiry = Int(googleDict["Expiry"]!)!
                print("Received google auth, expiry timestamp: " + googleDict["Expiry"]!)
                Auth.sharedInstance.loggedIn = true
                Auth.sharedInstance.delegate?.didReceiveAuth()
            } else {
                print("Did not receive token/auth, login failed.")
                Auth.sharedInstance.delegate?.didNotReceiveAuth()
            }
        })
        
        task.resume()
    }
}
