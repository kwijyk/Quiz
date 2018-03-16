//
//  MainMenuViewController.swift
//  Quiz
//
//  Created by Sergey Gaponov on 3/11/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit
import GameKit

class MainMenuViewController: UIViewController {

    private var gcEnabled = Bool() // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        authenticateLocalPlayer()
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error == nil {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // MARK: - Private methods
    @IBAction private func newGameAction(_ sender: Any) {
        let playModeVC = PlayModeViewController()
        navigationController?.pushViewController(playModeVC, animated: true)
    }
    
    @IBAction private func leaderboardAction(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
//        gcVC.viewState = .leaderboards
//        gcVC.leaderboardIdentifier = Constants.LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
}

//MARK: - GKGameCenterControllerDelegate
extension MainMenuViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

