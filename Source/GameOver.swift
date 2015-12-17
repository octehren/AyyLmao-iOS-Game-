//
//  GameOver.swift
//  AyyLmao
//
//  Created by Otavio Monteagudo on 12/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
import GameKit;

class GameOver:CCNode, GKGameCenterControllerDelegate {
    
    weak var musicButton:CCButton!;
    
    weak var soundButton:CCButton!;
    
    weak var highScore:CCLabelTTF!;
    
    weak var totalScore:CCLabelTTF!;
    
    weak var newHiScore:CCSprite!;
    
    /* bools */
    
    var soundOn:Bool = true;
    
    var musicOn:Bool = true;
    
    /* numbers */
    
    var currentBest:Int!;
    
    var currentScore:Int!;
    
    func didLoadFromCCB() {
        let soundOn = NSUserDefaults.standardUserDefaults().integerForKey("soundOn");
        if (soundOn == 1) {
            self.soundOn = true;
        } else {
            self.soundOn = false;
        }
    }
    
    /* button methods */
    
    func restartGame() {
        if (self.soundOn) {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "soundOn");
            //OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        } else {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "soundOn");
        }
        var gameplay = CCBReader.loadAsScene("Gameplay");
        let transition = CCTransition(fadeWithDuration: 1);
        CCDirector.sharedDirector().presentScene(gameplay, withTransition: transition);
    }
    
    func music() {
        self.musicButton.selected = self.musicOn;
        self.musicOn = !self.musicOn;
        if (self.musicOn) {
            OALSimpleAudio.sharedInstance().playBgWithLoop(true);
        } else {
            OALSimpleAudio.sharedInstance().stopBg();
        }
        if (self.soundOn) {
            OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        }
    }
    
    func sound() {
        self.soundButton.selected = self.soundOn;
        self.soundOn = !self.soundOn;
        if (self.soundOn) {
            OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        } else {
            OALSimpleAudio.sharedInstance().stopAllEffects();
        }
    }
    
    func facebook() {
        if (self.soundOn == true) {
            OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        }
        SharingHandler.sharedInstance.postToFacebook(postWithScreenshot: true);
    }
    
    func twitter() {
        if (self.soundOn == true) {
            OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        }
        SharingHandler.sharedInstance.postToTwitter(stringToPost: "I've just ayylmao'd \(self.currentScore) times in AyyLmao. Congratulate me or I'll block you.", postWithScreenshot: true);
    }
    
    func gameCenter() {
        if (self.soundOn == true) {
            OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        }
        self.setUpGameCenter();
        self.reportHighScoreToGameCenter();
        self.showLeaderboard();
    }
    
    /* custom methods */
    
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance;
        gameCenterInteractor.authenticationCheck();
    }
    
    func isHighscore(score: Int) {
        self.currentScore = score;
        let defaults = NSUserDefaults.standardUserDefaults();
        let highscore:Int? = defaults.integerForKey("highscore");
        if (highscore != nil) {
            self.currentBest = highscore!;
        }
        if (self.currentScore > self.currentBest) {
            self.updateHighscore();
        }
        self.updateLabels();
    }
    
    func updateLabels() {
        self.totalScore.string = "\(self.currentScore)";
        self.highScore.string = "\(self.currentBest)";
    }
    
    func updateHighscore() {
        NSUserDefaults.standardUserDefaults().setInteger(self.currentScore, forKey: "highscore");
        self.currentBest = self.currentScore;
        self.newHiScore.visible = true;
    }
    
    /* GameKit methods */
    
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!;
        var gameCenterViewController = GKGameCenterViewController();
        gameCenterViewController.gameCenterDelegate = self;
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil);
    }
    
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reportHighScoreToGameCenter() {
        var scoreReporter = GKScore(leaderboardIdentifier: "Ayyyy.Lmao");
        scoreReporter.value = Int64(self.currentBest);// = Int64(GameCenterInteractor.sharedInstance.score);
        var scoreArray: [GKScore] = [scoreReporter];
        
        GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
            if error != nil {
                println("Game Center: Score Submission Error");
            }
        });
    }
}