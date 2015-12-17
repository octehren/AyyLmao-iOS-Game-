//
//  AyyLabel.swift
//  AyyLmao
//
//  Created by Otavio Monteagudo on 11/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class AyyLabel: CCNode {
    //weak var background:CCNodeColor!;
    weak var ayyLmao:CCLabelTTF!;
    
    func buildLabel() {
        var random = arc4random_uniform(UInt32(8));
        var fontName:String!;
        if (random < 2) {
            fontName = "DaftFont.TTF";
        } else if (random < 4) {
            fontName = "Soviet2b.ttf";
        } else if (random < 6) {
            fontName = "1942.ttf";
        } else {
            fontName = "2Dumb.ttf";
        }
        self.ayyLmao.fontName = fontName;
    }
    
    func setPhrase(phrase: String) {
        self.ayyLmao.string = phrase;
    }
    
    func getPhrase() -> String {
        return self.ayyLmao.string;
    }
    
    func setAyyLmao() {
        self.ayyLmao.string = "AYY LMAO";
    }
}
