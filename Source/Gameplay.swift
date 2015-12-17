//
//  Gameplay.swift
//  AyyLmao
//
//  Created by Otavio Monteagudo on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Gameplay: CCNode {
    //UI Elements
    weak var timerBar:CCNodeColor!;
    weak var grid:Grid!;
    weak var background:CCSprite!;
    weak var scoreLabel:CCLabelBMFont!;
    
    // numbers
    let totalBackgrounds = 3;
    
    var timeLeft:Float = 10 {
        didSet {
            self.timeLeft = max(min(self.timeLeft, 10), 0);
            self.timerBar.scaleX = self.timeLeft / Float(10);
        }
    }
    
    var timePassed:CGFloat = 0;
    
    var timeRatio:CGFloat = 20;
    
    var counter:Int = 0 {
        didSet {
            if (self.counter % 5 == 0) {
                self.increaseDifficulty();
                self.setRandomBackground();
                self.changeBarColor();
            }
        }
    }
    
    var turn:CGFloat = 0;
    
    var labelHeight:CGFloat!;
    var labelWidth:CGFloat!;
    
    // bools
    
    var soundOn:Bool!;
    
    // UI methods
    func changeBarColor() {
        let red:Float = Float(arc4random_uniform(256)) / 255.0;
        let green = Float(arc4random_uniform(256)) / 255.0;
        let blue = Float(arc4random_uniform(256)) / 255.0;
        self.timerBar.color = CCColor(red: red, green: green, blue: blue);
    }
    
    func setRandomBackground() {
        self.background.spriteFrame = CCSpriteFrame(imageNamed: "Backgrounds/\(arc4random_uniform(UInt32(self.totalBackgrounds))).png");
    }
    
    /* cocos2d methods */
    
    func didLoadFromCCB() {
        let soundOn = NSUserDefaults.standardUserDefaults().integerForKey("soundOn");
        if (soundOn == 1) {
            self.soundOn = true;
        } else {
            self.soundOn = false;
        }
    }
    
    override func onEnter() {
        super.onEnter();
        self.timerBar.zOrder = 10;
        self.scoreLabel.zOrder = 11;
        self.setRandomBackground();
        self.changeBarColor();
        self.labelWidth = self.grid.labels[0][0].contentSizeInPoints.width;
        self.labelHeight = self.grid.labels[0][0].contentSizeInPoints.height;
    }
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish();
        self.userInteractionEnabled = true;
        self.schedule("tickTock", interval: 0.05);
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(self.grid.labelsNode);
        
        if let ayyLabel = self.getLabel(touchLocation) {
            if (self.isRightLabel(ayyLabel)) {
                self.grid.rebuildGrid();
                self.counter += 1;
                self.turn += 1;
                self.timePassed = 0;
                self.scoreLabel.setString("\(self.counter)");
                if (self.soundOn == true) {
                    OALSimpleAudio.sharedInstance().playEffect("ting.wav");
                }
            } else {
                self.gameOver();
            }
        }
    }
    
    /* custom game mechanics methods */
    
    func getLabel(touchPoint: CGPoint) -> AyyLabel? {
        let posX = Int(touchPoint.x / self.labelWidth);
        let posY = Int(touchPoint.y / self.labelHeight);
        if (posX >= 0 && posX < self.grid.columns) {
            if (posY >= 0 && posY < self.grid.rows) {
                if (self.grid.labels[posY][posX].visible) {
                    return self.grid.labels[posY][posX];
                }
            }
        }
        return nil;
    }
    
    func isRightLabel(label: AyyLabel) -> Bool {
        return label.getPhrase() == "AYY LMAO";
    }
    
    func increaseDifficulty() {
        self.grid.rearrangeLabels();
        // cut the player some slack when an extra tile is added.
        self.turn -= 3;
    }
    
    func tickTock() {
        if (self.timePassed > 90) {
            self.gameOver();
        }
        let time = 1 + (self.turn/self.timeRatio);

        self.timePassed = self.timePassed + time;
        
        self.timeLeft = Float((90 - self.timePassed) / 90) * 10;
    }
    
    /* UI methods */
    
    func gameOver() {
        self.unschedule("tickTock");
        self.userInteractionEnabled = false;
        if (self.soundOn == true) {
            OALSimpleAudio.sharedInstance().playEffect("lose.wav");
        }
        self.schedule("displayGameOver", interval: 0.2);
    }
    
    func displayGameOver() {
        self.unschedule("displayGameOver");
        iAdHandler.sharedInstance.displayInterstitialAd();
        var gameEndPopover = CCBReader.load("GameOver") as! GameOver;
        gameEndPopover.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.5);
        gameEndPopover.zOrder = 9999;
        gameEndPopover.isHighscore(self.counter);
        self.addChild(gameEndPopover);
    }
}