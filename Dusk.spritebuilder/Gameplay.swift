//
//  Gameplay.swift
//  Dusk
//
//  Created by Alan on 7/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

enum FuzzColor {
    case Blue, Green, Red, Yellow, White
}
class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    weak var fuzz1: Fuzz!
    weak var fuzz2: Fuzz!
    weak var tapToStart: CCLabelTTF!
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var scoreLabel: CCLabelTTF!
    weak var restartButton: CCButton!
    weak var restartScreen: CCSprite!
    weak var restartScore: CCLabelTTF!
    weak var highscoreLabel: CCLabelTTF!
    weak var colorGrass: CCSprite!
    weak var colorPlants: CCSprite!
    weak var colorTree: CCSprite!
    weak var colorSecond: CCSprite!
    weak var colorBG: CCSprite!
    weak var colorSky: CCSprite!
    var sapling: Sapling?
    var fuzzies: [Fuzz] = []
    var gameOver = false
    var points : NSInteger = 0
    var currentFuzz: Fuzz!
    var bothFuzz = false
    var oneGameOver = false
    var firstTap = false
    var firstFirst = false
    var whichFuzz = 0
    
    func addColors(){
        if points >= 5 {
            colorGrass.visible = true
        }
        if points >= 10 {
            colorPlants.visible = true
        }
        if points >= 25{
            colorTree.visible = true
        }
        if points >= 40{
            colorSecond.visible = true
        }
        if points >= 70{
            colorBG.visible = true
        }
        if points >= 100{
            colorSky.visible = true
        }
    }
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if firstFirst == false{
            firstTap = true
            firstFirst = true
        }
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "highscore" {
            updateHighscore()
        }
    }
    func updateHighscore() {
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highscoreLabel.string = "\(newHighscore)"
    }
    func triggerGameOver(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        if points > highscore {
            defaults.setInteger(points, forKey: "highscore")
        }
        restartButton.visible = true
        restartScreen.visible = true
        restartScore.visible = true
        highscoreLabel.visible = true
        self.animationManager.runAnimationsForSequenceNamed("FadeIn")
    }
    func restart(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        points = 0
    }
    /*
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: Fuzz!, level: CCNode!) -> Bool {
        if oneGameOver == false{
            triggerGameOver()
            gameOver = true
            for fuzz in fuzzies {
                fuzz.white()
            }
            oneGameOver = true
        }
        //add the sapling animation
        sapling = CCBReader.load("Sapling") as! Sapling?
        if let sapling = sapling{
            var curPos = ball.convertToWorldSpace(CGPoint(x: 0, y: 0))
            sapling.position = gamePhysicsNode.convertToNodeSpace(curPos)
            gamePhysicsNode.addChild(sapling)
        }
        return true
    }
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, ball: Fuzz!, level: CCNode!) {
        gamePhysicsNode.space.addPostStepBlock({
            ball.ground()
            for fuzz in self.fuzzies{
                if fuzz.touchGround == true{
                    self.fuzzies.removeAtIndex(self.whichFuzz)
                    break
                }
                self.whichFuzz++
            }
            self.whichFuzz = 0
            ball.removeFromParent()
            }, key: ball)
    }
    */
    func veryBeginning(){
        tapToStart.visible = false
        self.animationManager.runAnimationsForSequenceNamed("Main")
        fuzzies.append(fuzz1)
        currentFuzz = fuzz1
        changeColor()
        fuzzies.append(fuzz2)
        currentFuzz = fuzz2
        changeColor()
        firstTap = false
    }
    func didLoadFromCCB(){
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        self.animationManager.runAnimationsForSequenceNamed("Beginning")
        NSUserDefaults.standardUserDefaults().addObserver(self, forKeyPath: "highscore", options: .allZeros, context: nil)
        updateHighscore()
    }
    func changeColor(){
        var whichColor = Int(CCRANDOM_0_1() * 4)
        var horizMove = CGFloat(CCRANDOM_0_1() * 100 - 50)
        //applies the "bounce" the fuzz does
        currentFuzz.physicsBody.velocity = ccp(0,200)
        currentFuzz.physicsBody.velocity = ccp(horizMove, currentFuzz.physicsBody.velocity.y)
        //updates the score
        points++
        scoreLabel.string = String(points)
        restartScore.string = String(points)
        //changes the color of the fuzz
        addColors()
        if whichColor == 0{
            currentFuzz.blue()
        } else if whichColor == 1{
            currentFuzz.green()
        } else if whichColor == 2{
            currentFuzz.red()
        } else {
            currentFuzz.yellow()
        }
    }
    override func update(delta: CCTime) {
        if fuzzies.count == 2 {
            for fuzz in fuzzies {
                fuzz.physicsBody.applyImpulse(ccp(0,-70))
            }
        }
        if fuzzies.count == 1{
            fuzzies[0].physicsBody.applyImpulse(ccp(0,-70))
        }
        if firstTap {
            veryBeginning()
        }
    }
    func pressBlue(){
        if gameOver == false{
            for fuzz in fuzzies {
                currentFuzz = fuzz
                if fuzz.fuzzColor == .Blue {
                    changeColor()
                    bothFuzz = true
                }
            }
            if bothFuzz == false{
                for fuzz in fuzzies {
                    fuzz.white()
                    gameOver = true
                }
            }
        }
    }
    func pressGreen(){
        if gameOver == false{
            for fuzz in fuzzies {
                currentFuzz = fuzz
                if fuzz.fuzzColor == .Green {
                    changeColor()
                    bothFuzz = true
                }
            }
            if bothFuzz == false{
                for fuzz in fuzzies {
                    fuzz.white()
                    gameOver = true
                }
            }
        }
    }
    func pressRed(){
        if gameOver == false{
            for fuzz in fuzzies {
                currentFuzz = fuzz
                if fuzz.fuzzColor == .Red {
                    changeColor()
                    bothFuzz = true
                }
            }
            if bothFuzz == false{
                for fuzz in fuzzies {
                    fuzz.white()
                    gameOver = true
                }
            }
        }
    }
    func pressYellow(){
        if gameOver == false{
            for fuzz in fuzzies {
                currentFuzz = fuzz
                if fuzz.fuzzColor == .Yellow {
                    changeColor()
                    bothFuzz = true
                }
            }
            if bothFuzz == false{
                for fuzz in fuzzies {
                    fuzz.white()
                    gameOver = true
                }
            }
        }
    }
}
