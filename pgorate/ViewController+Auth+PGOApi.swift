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
        showAlert("Login Failed", message: "Please check your credentials and try again.")
    }
    
    func didReceiveApiResponse(intent: ApiIntent, response: ApiResponse) {
        if (intent == .Login) {
            Api.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
            let request = PGoApiRequest()
            request.getPlayer()
            request.getInventory()
            request.makeRequest(.GetMapObjects, delegate: self)
        } else if (intent == .GetMapObjects) {
            let player = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetPlayerResponse
            let inventory = response.subresponses[1] as! Pogoprotos.Networking.Responses.GetInventoryResponse
            
            if player.hasPlayerData {
                playerData = player.playerData
            }
            
            if inventory.hasInventoryDelta {
                inventoryItems = inventory.inventoryDelta.inventoryItems
            }
            
        }
    }
    
    func didReceiveApiError(intent: ApiIntent, statusCode: Int?) {
        showAlert("Oops", message: "The API encountered an error. Error code: \(statusCode)")
    }
}