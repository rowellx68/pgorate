//
//  ViewController+Auth+PGOApi.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import Eureka
import PGoApi

extension ViewController: PGoAuthDelegate, PGoApiDelegate {
    func didReceiveAuth() {
        let request = PGoApiRequest()
        
        request.simulateAppStart()
        request.makeRequest(.Login, auth: auth, delegate: self)
    }
    
    func didNotReceiveAuth() {
        disableInput(withCondition: false)
        removeActivityIndicator()
        showAlert("Login Failed", message: "Please check your credentials and try again.\n\nIf you have enabled 2FA for your Google account, create an app specific password.")
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .Login) {
            let request = PGoApiRequest()
            request.getPlayer()
            request.getInventory()
            
            auth.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
            request.makeRequest(.GetMapObjects, auth: auth, delegate: self)
            
        } else if (intent == .GetMapObjects) {
            if response.subresponses.count == 2 {
                let player = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetPlayerResponse
                let inventory = response.subresponses[1] as! Pogoprotos.Networking.Responses.GetInventoryResponse
                
                if player.hasPlayerData {
                    playerData = player.playerData
                }
                
                if inventory.hasInventoryDelta {
                    inventoryItems = inventory.inventoryDelta.inventoryItems
                }
                
                removeActivityIndicator()
                performSegueWithIdentifier("showPokemonListSegue", sender: nil)
            } else {
                disableInput(withCondition: false)
                removeActivityIndicator()
                showAlert("Oops", message: "An error occured. We didn't receive enough data from the server. It might be experiencing some issues.")
            }
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        disableInput(withCondition: false)
        removeActivityIndicator()
        showAlert("Oops", message: "An error occured. The login or game servers might be down. Try again later.")
    }
}