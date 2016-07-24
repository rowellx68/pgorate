//
//  ViewController+Auth+PGOApi.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
extension ViewController: AuthDelegate, PGoApiDelegate {
    func didReceiveAuth() {
        let request = PGoApiRequest()
        request.simulateAppStart()
        request.makeRequest(.Login, delegate: self)
    }
    
    func didNotReceiveAuth() {
        print("Failed to auth!")
    }
    
    func didReceiveApiResponse(intent: ApiIntent, response: ApiResponse) {
        if (intent == .Login) {
            Api.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
            let request = PGoApiRequest()
            request.makeRequest(.GetMapObjects, delegate: self)
        } else if (intent == .GetMapObjects) {
            print(response.response)
            print(response.subresponses)
        }
    }
    
    func didReceiveApiError(intent: ApiIntent, statusCode: Int?) {
        print("API Error: \(statusCode)")
    }
}