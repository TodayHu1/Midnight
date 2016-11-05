//
//  GameScene.swift
//  MatchRPG
//
//  Created by David Garrett on 6/21/16.
//  Copyright (c) 2016 David Garrett. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var level: Level!
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    var layerPosition: CGPoint!
    
    let gameLayer = SKNode()
    let tokensLayer = SKNode()
    
    var swipeFromColumn: Int?
    var swipeFromRow: Int?
    
    var swipeHandler: ((Swap) -> ())?
    var selectionSprite = SKSpriteNode()
    
    let swapSound = SKAction.playSoundFileNamed("Sounds/Chomp.wav", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("Sounds/Error.wav", waitForCompletion: false)
    let matchSound = SKAction.playSoundFileNamed("Sounds/Ka-Ching.wav", waitForCompletion: false)
    let fallingTokenSound = SKAction.playSoundFileNamed("Sounds/Scrape.wav", waitForCompletion: false)
    let addTokenSound = SKAction.playSoundFileNamed("Sounds/Drip.wav", waitForCompletion: false)
    
    var options: GameOptions = GameOptions()
    
    var elapsedTime: TimeInterval = 0
    var timer: Timer = Timer()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func update(_ currentTime: TimeInterval) {
        timer.advance()
        elapsedTime += timer.dt
        super.update(currentTime)
    }
    
    func setupLevel(_ newLevel: Level) {
        self.level = newLevel
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
//        let background = SKSpriteNode(imageNamed: level.background)
//        background.size = size
//        addChild(background)
        
        gameLayer.isHidden = true
        addChild(gameLayer)
        
        let y: CGFloat = size.height / 4
        
        layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: (-TileHeight * CGFloat(NumRows) / 2) - y)

        tokensLayer.position = layerPosition
        gameLayer.addChild(tokensLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
        let _ = SKLabelNode(fontNamed: "DigitalStripBB-BoldItalic")
    }
    
    func addSpritesForTokens(_ tokens: Set<Token>) {
        for token in tokens {
            let sprite = SKSpriteNode(imageNamed: token.tokenType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)

            sprite.position = pointForColumn(token.column, row: token.row)
            tokensLayer.addChild(sprite)
            token.sprite = sprite
            
            sprite.alpha = 0
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            
            sprite.run(
                SKAction.sequence([
                    SKAction.wait(forDuration: 0.25, withRange: 0.5),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: 0.25),
                        SKAction.scale(to: 1.0, duration: 0.25)
                        ])
                    ])
            )
        }
    }
    
    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth / 2,
            y: CGFloat(row)*TileHeight + TileHeight / 2
        )
    }
    
    func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth && point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0) //invalid location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: tokensLayer)
        let (success, column, row) = convertPoint(location)
        if success {
            if let token = level.tokenAtColumn(column, row: row) {
                swipeFromColumn = column
                swipeFromRow = row
                showSelectionIndicatorForToken(token)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard swipeFromColumn != nil else {return}
        
        guard let touch = touches.first else {return}
        let location = touch.location(in: tokensLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            var horzDelta = 0, vertDelta = 0
            
            if column < swipeFromColumn! {          // left swipe
                horzDelta = -1
            } else if column > swipeFromColumn! {   // right swipe
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            
            if horzDelta != 0 || vertDelta != 0 {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                hideSelectionIndicator()
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, with: event)
        }
    }
    
    func trySwapHorizontal(_ horzDelta: Int, vertical vertDelta: Int) {
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        
        guard toColumn >= 0 && toColumn < NumColumns else {return}
        guard toRow >= 0 && toRow < NumRows else {return}
        
        if let toToken = level.tokenAtColumn(toColumn, row: toRow), let fromToken = level.tokenAtColumn(swipeFromColumn!, row: swipeFromRow!) {
            if let handler = swipeHandler {
                let swap = Swap(tokenA: fromToken, tokenB: toToken)
                handler(swap)
            }
        }
    }
    
    func animateSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.tokenA.sprite!
        let spriteB = swap.tokenB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: Duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: Duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
        
        if options.playSounds {
            run(swapSound)
        }
    }
    
    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.tokenA.sprite!
        let spriteB = swap.tokenB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: TimeInterval = 0.2
        
        
        let moveA = SKAction.move(to: spriteB.position, duration: Duration)
        moveA.timingMode = .easeOut
        
        let moveB = SKAction.move(to: spriteA.position, duration: Duration)
        moveB.timingMode = .easeOut
        
        spriteA.run(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteB.run(SKAction.sequence([moveB, moveA]))
        
        if options.playSounds {
            run(invalidSwapSound)
        }
    }
    
    func animateMatchedTokens(_ chains: Set<Chain>, monster: Monster, completion: @escaping () -> ()) {
        for chain in chains {
            animateScoreForChain(chain, monster: monster)
            for token in chain.tokens {
                if let sprite = token.sprite {
                    if sprite.action(forKey: "removing") == nil {
                        let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
                        scaleAction.timingMode = .easeOut
                        sprite.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]), withKey: "removing")
                    }
                }
            }
        }
        if options.playSounds {
            run(matchSound)
        }
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    func animateFallingTokens(_ columns: [[Token]], completion: @escaping () -> ()) {
        var longestDuration: TimeInterval = 0
        for array in columns {
            for (idx, token) in array.enumerated() {
                let newPosition = pointForColumn(token.column, row: token.row)
                let delay = 0.05 + 0.15*TimeInterval(idx)
                let sprite = token.sprite!
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                if options.playSounds {
                    sprite.run(
                        SKAction.sequence([
                            SKAction.wait(forDuration: delay),
                            SKAction.group([moveAction, fallingTokenSound])]))
                }
                else {
                    sprite.run(
                        SKAction.sequence([
                            SKAction.wait(forDuration: delay),
                            SKAction.group([moveAction])]))
                }
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func animateNewTokens(_ columns: [[Token]], completion: @escaping () -> ()) {
        var longestDuration: TimeInterval = 0
        
        for array in columns {
            let startRow = array[0].row + 1
            
            for (idx, token) in array.enumerated() {
                let sprite = SKSpriteNode(imageNamed: token.tokenType.spriteName)
                sprite.size = CGSize(width: TileWidth, height: TileHeight)
                sprite.position = pointForColumn(token.column, row: startRow)
                tokensLayer.addChild(sprite)
                token.sprite = sprite
                
                let delay = 0.1 + 0.2 * TimeInterval(array.count - idx - 1)
                
                let duration = TimeInterval(startRow - token.row) * 0.1
                longestDuration = max(longestDuration, duration - delay)
                
                let newPosition = pointForColumn(token.column, row: token.row)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                
                sprite.alpha = 0
                if options.playSounds {
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.05),
                            moveAction,
                            addTokenSound])
                        ]))
                } else {
                    sprite.run(
                        SKAction.sequence([
                            SKAction.wait(forDuration: delay),
                            SKAction.group([
                                SKAction.fadeIn(withDuration: 0.05),
                                moveAction])
                            ]))
                }
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func animateScoreForChain(_ chain: Chain, monster: Monster) {
        let firstSprite = chain.firstToken().sprite!
        let lastSprite = chain.lastToken().sprite!
        let centerPosition = CGPoint(
            x: (firstSprite.position.x + lastSprite.position.x) / 2,
            y: (firstSprite.position.y + lastSprite.position.y) / 2 - 8)
        
        let scoreLabel = SKLabelNode(fontNamed: "DigitalStripBB-BoldItalic")
        scoreLabel.fontSize = 17
        scoreLabel.text = String(format: "%ld", chain.score)
        if chain.firstToken().tokenType == monster.vulnerability {
            scoreLabel.fontColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        } else if chain.firstToken().tokenType == monster.resistance {
            scoreLabel.fontColor = UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.00)
        }
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        tokensLayer.addChild(scoreLabel)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 0.7)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func animateCharacterDamage(_ criticalHit: Bool, monsterDamage: Int, centerPosition: CGPoint) {
        let scoreLabel = SKLabelNode(fontNamed: "DigialStripBB")
        scoreLabel.fontSize = 17
        scoreLabel.text = String(format: "%ld", monsterDamage)
        if criticalHit {
            scoreLabel.color = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
        }
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        tokensLayer.addChild(scoreLabel)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 0.7)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }

    func animateBigText(text: String, color: UIColor = UIColor.white) {
        let scoreLabel = SKLabelNode(fontNamed: "SilverBulletBB")
        scoreLabel.fontSize = 72
        scoreLabel.text = text
        scoreLabel.fontColor = color
        
        let gridCenter = CGPoint(x: TileWidth * CGFloat(NumColumns) / 2, y: TileHeight * CGFloat(NumRows) / 2)
        
        scoreLabel.position = gridCenter
        scoreLabel.zPosition = 300
        tokensLayer.addChild(scoreLabel)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1.5)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func showSelectionIndicatorForToken(_ token: Token) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = token.sprite {
            let texture = SKTexture(imageNamed: token.tokenType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
            selectionSprite.run(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
    }
    
    func animateGameOver(_ completion: @escaping () -> ()) {
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.3)
        action.timingMode = .easeIn
        gameLayer.run(action, completion: completion)
    }
    
    func animateBeginGame(_ completion: @escaping () -> ()) {
        gameLayer.isHidden = false
        gameLayer.position = CGPoint(x: 0, y: size.height)
        elapsedTime = 0
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.3)
        action.timingMode = .easeOut
        gameLayer.run(action, completion: completion)
    }
    
    func removeAllTokenSprites() {
        tokensLayer.removeAllChildren()
    }
}

