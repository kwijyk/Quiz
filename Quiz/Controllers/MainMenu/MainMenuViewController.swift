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
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        authenticateLocalPlayer()
    }
    
//  MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { [weak self] (ViewController, error) in
            if((ViewController) != nil) {
                self?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self?.gcEnabled = true
                self?.fetchUsersScore(leaderboardID: Constants.LifeLeaderboard_ID, complition: { userScore in
                    UserDefaults.standard.set(userScore, forKey: Constants.MaxLifeUserScoreKey)
                })
            } else {
                self?.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // MARK: - Private methods
    private func fetchUsersScore(leaderboardID: String, complition: @escaping (Int) -> Void) {
        let leaderboardRequest = GKLeaderboard()
        leaderboardRequest.identifier = Constants.LifeLeaderboard_ID
        leaderboardRequest.loadScores { scores, error in
            if error != nil {
                print("Error load score")
                complition(0)
            } else{
                guard let score = leaderboardRequest.localPlayerScore?.value else { return }
                complition(Int(score))
            }
        }
    }
    
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

