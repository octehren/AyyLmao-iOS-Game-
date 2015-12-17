//
//  Grid.swift
//  AyyLmao
//
//  Created by Otavio Monteagudo on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Grid: CCSprite {
    /* UI elements */
    weak var labelsNode:CCNode!;
    
    /* numbers */
    let rows:Int = 3;
    let columns:Int = 4;
    var labelHeight:CGFloat!// = self.contentSize.height;
    var labelWidth:CGFloat!// = self.contentSize.width;
    
    /* arrays */
    var labels:[[AyyLabel]] = [];
    var invisibleLabels:[[Int]] = [];
    var visibleLabels:[[Int]] = [];
    
    var phrases:[String] = [
      "AYY RLMFAO",
      "RLMFAO",
      "LMAO",
      "TOP LEL",
      "LULZ",
      "LMFAO",
      "AYY LMFAO",
      "ROLMFAO",
      "AYY ROLMFAO"
    ];
    
    /* cocos2d methods */
    
    override func onEnter() {
        super.onEnter();
        self.buildGrid();
        self.makeRandomLabelVisible();
        self.makeRandomLabelVisible();
        self.makeRandomLabelVisible();
        self.makeAyyLmaoLabel();
    }
    
    /* UI methods */
    
    func buildGrid() {
        var labelRow:[AyyLabel];
        var labelHeight:CGFloat = self.labelsNode.contentSize.height / CGFloat(self.rows);
        var labelWidth:CGFloat = self.labelsNode.contentSize.width / CGFloat(self.columns);
        for (var r = 0; r < self.rows; r++) {
            labelRow = [];
            for (var c = 0; c < self.columns; c++) {
                var ayyLabel = CCBReader.load("AyyLabel") as! AyyLabel;
                ayyLabel.visible = false;
                ayyLabel.buildLabel();
                ayyLabel.setPhrase(self.phrases[Int(arc4random_uniform(UInt32(self.phrases.count)))]);
                self.labelsNode.addChild(ayyLabel);
                ayyLabel.positionInPoints.x = ayyLabel.contentSizeInPoints.width * CGFloat(c) + ayyLabel.contentSizeInPoints.width * 0.5;
                ayyLabel.positionInPoints.y = ayyLabel.contentSizeInPoints.height * CGFloat(r) + ayyLabel.contentSizeInPoints.height * 0.5;
                labelRow.append(ayyLabel);
                self.invisibleLabels.append([r,c]);
            }
            self.labels.append(labelRow);
        }
    }
    
    func rebuildGrid() {
        for (var v = self.visibleLabels.count - 1; v >= 0; v--) {
            var label = self.labels[self.visibleLabels[v][0]][self.visibleLabels[v][1]];
            label.buildLabel();
            label.setPhrase(self.phrases[Int(arc4random_uniform(UInt32(self.phrases.count)))]);
        }
        self.makeAyyLmaoLabel();
    }
    
    /* custom methods */
    
    func makeRandomLabelVisible() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.invisibleLabels.count)));
        let randomLabel = self.invisibleLabels[randomIndex];
        var ayyLabel = self.labels[randomLabel[0]][randomLabel[1]];
        ayyLabel.visible = true;
        ayyLabel.setPhrase(self.phrases[Int(arc4random_uniform(UInt32(self.phrases.count)))]);
        self.visibleLabels.append(randomLabel);
        self.invisibleLabels.removeAtIndex(randomIndex);
    }
    
    func rearrangeLabels() {
        if (self.invisibleLabels.count > 0) {
            for (var i = self.visibleLabels.count - 1; i >= 0; --i) {
                self.invisibleLabels.append(self.visibleLabels[i]);
                self.labels[self.visibleLabels[i][0]][self.visibleLabels[i][1]].visible = false;
                self.visibleLabels.removeAtIndex(i);
                self.makeRandomLabelVisible();
            }
            // make an extra label visible.
            self.makeRandomLabelVisible();
            // make one of the labels a "right" one
            self.makeAyyLmaoLabel();
        }
    }
    
    func makeAyyLmaoLabel() {
        let randomLabel = self.visibleLabels[Int(arc4random_uniform(UInt32(self.visibleLabels.count)))];
        self.labels[randomLabel[0]][randomLabel[1]].setAyyLmao();
    }
    
}
