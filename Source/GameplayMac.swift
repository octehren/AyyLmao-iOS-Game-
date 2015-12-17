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
    
    // numbers
    let totalBackgrounds = 2;
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
    
    override func onEnter() {
        super.onEnter();
        self.timerBar.zOrder = 10;
        self.setRandomBackground();
        self.changeBarColor();
        self.labelWidth = self.grid.labels[0][0].contentSizeInPoints.width;
        self.labelHeight = self.grid.labels[0][0].contentSizeInPoints.height;
    }
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish();
        self.userInteractionEnabled = true;
        self.schedule("tickTock", interval: 0.1);
    }
    
    /* custom game mechanics methods */
    
    func getLabel(touchPoint: CGPoint) -> AyyLabel? {
        let posX = Int(touchPoint.x / self.labelWidth);
        let posY = Int(touchPoint.y / self.labelHeight);
        println(posX);
        println(posY);
        if (posX >= 0 && posX < self.grid.columns) {
            if (posY >= 0 && posY < self.grid.rows) {
                return self.grid.labels[posY][posX];
            }
        }
        return nil;
    }
    
    func isRightLabel(label: AyyLabel) -> Bool {
        return label.getPhrase() == "AYY LMAO";
    }
    
    func increaseDifficulty() {
        self.grid.makeRandomLabelVisible();
        // cut the player some slack when an extra tile is added.
        self.turn -= 2;
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
    }
}