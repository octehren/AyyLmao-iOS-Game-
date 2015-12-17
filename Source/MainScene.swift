import Foundation;

class MainScene: CCNode {
    
    weak var musicButton: CCButton!;
    
    weak var soundButton:CCButton!;
    
    weak var instructions:CCNodeColor!;
    
    var soundOn:Bool = true;
    
    var musicOn:Bool = true;
    
    /* button methods */
    
    func didLoadFromCCB() {
        OALSimpleAudio.sharedInstance().preloadBg("beethoven.wav");
        iAdHandler.sharedInstance.loadInterstitialAd();
    }
    
    override func onEnter() {
        super.onEnter();
        OALSimpleAudio.sharedInstance().playBgWithLoop(true);
    }
    
    func gameStart() {
        if (self.soundOn) {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "soundOn");
            //OALSimpleAudio.sharedInstance().playEffect("ting.wav");
        } else {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "soundOn");
        }
        self.instructions.visible = true;
        self.userInteractionEnabled = true;
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
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (self.instructions.visible) {
            let gameplay = CCBReader.loadAsScene("Gameplay");
            let transition = CCTransition(fadeWithDuration: 1);
            CCDirector.sharedDirector().presentScene(gameplay, withTransition: transition);
        }
    }
}
