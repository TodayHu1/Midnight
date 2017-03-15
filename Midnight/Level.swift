//
//  Level.swift
//  MatchRPG
//
//  Created by David Garrett on 8/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

let NumColumns = 8
let NumRows = 8

struct LevelRewards {
    var totalMoves: Int = 0
    var totalDamageTaken: Int = 0
    var elapsedTime: Int = 0
}

class Level {
    private var tokens = Array2D<Token>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var possibleSwaps = Set<Swap>()
    var comboMultiplier = 0
    var noSwaps = false
    
    var monsters: [Monster] = [Monster]()
    var background = ""
    var music = ""
    var title = ""
    var completionRating = 0
    var goals: LevelResult = LevelResult()
    var result: LevelResult = LevelResult()
    var rewards: LevelRewards = LevelRewards()
    var questData: [String: AnyObject] = [String: AnyObject]()
    var scene: [String]?
    var postlude: [String]?
    var availableCharacters: [String]?
    var supportCharacters: [String]?
    
    init(filename: String) {
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
//        guard let tilesArray = dictionary["tiles"] as? [[Int]] else {return}
//        
//        for (row, rowArray) in tilesArray.enumerate() {
//            for (column, value) in rowArray.enumerate() {
//                if value == 1 {
//                    tiles[column, row] = Tile()
//                }
//            }
//        }
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
            tiles[column, row] = Tile()
            }
        }
        
        background = dictionary["background"] as! String
        music = dictionary["music"] as! String
        title = dictionary["title"] as! String
        let monsterArray = dictionary["monsters"] as! [String]
        for item in monsterArray {
            let monster = Monster(filename: "Monsters/\(item)")
            monsters.append(monster)
        }
        
        let goalsInfo = dictionary["goals"] as! [String: AnyObject]
        goals.totalMoves = goalsInfo["totalMoves"] as! Int
        goals.totalDamageTaken = goalsInfo["totalDamageTaken"] as! Int
        goals.elapsedTime = goalsInfo["elapsedTime"] as! TimeInterval
        
        let rewardsInfo = dictionary["rewards"] as! [String: AnyObject]
        rewards.totalMoves = rewardsInfo["totalMoves"] as! Int
        rewards.totalDamageTaken = rewardsInfo["totalDamageTaken"] as! Int
        rewards.elapsedTime = rewardsInfo["elapsedTime"] as! Int
        
        if let questDataArray = dictionary["questdata"] as? [[String: AnyObject]] {
            for item in questDataArray {
                let key = item["key"] as! String
                let value = item["value"]
                
                questData[key] = value
            }
        }
        
        scene = dictionary["scene"] as? [String]
        postlude = dictionary["postlude"] as? [String]
        
        if let availableCharacterArray : [String] = dictionary["characters"] as? [String] {
            availableCharacters = availableCharacterArray
        }
        
        if let supportCharacterArray : [String] = dictionary["supportCharacters"] as? [String] {
            supportCharacters = supportCharacterArray
        }
    }
    
    func tokenAtColumn(_ column: Int, row: Int) -> Token? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tokens[column, row]
    }
    
    func tileAtColumn(_ column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Token> {
        var set: Set<Token>
        
        repeat {
            set = createInitialTokens()
            detectPossibleSwaps()
        } while possibleSwaps.count == 0
        
        return set
    }
    
    func poison() -> Set<Token> {
        var set = Set<Token>()
        
        for _ in 1...NumRows {
            let column = Int(arc4random_uniform(UInt32(NumColumns)))
            let row = Int(arc4random_uniform(UInt32(NumRows)))
            
            if tokens[column, row]?.status == TokenStatus.None {
                tokens[column, row]?.status = .Poison
                set.insert(tokens[column, row]!)
            }
        }
        return set
    }
    
    func hide() -> Set<Token> {
        var set = Set<Token>()
        
        let columnRange = Range(uncheckedBounds: (lower: 2, upper: NumColumns - 1))
        let rowRange = Range(uncheckedBounds: (lower: 2, upper: NumRows - 1))
        
        let originColumn = Int.random(range: columnRange)
        let originRow = Int.random(range: rowRange)
        
        for row in originRow - 1...originRow + 1 {
            for column in originColumn - 1...originColumn + 1 {
                if tokens[column, row]?.status == TokenStatus.None {
                    tokens[column, row]?.status = .Hidden
                    set.insert(tokens[column, row]!)
                }
            }
        }
        return set
    }
    
    func countPoisonTokens() -> Int {
        var tokenCount = 0
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tokens[row, column]?.status == .Poison {
                    tokenCount += 1
                }
            }
        }
        return tokenCount
    }
    
    func createInitialTokens() -> Set<Token> {
        var set = Set<Token>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] != nil {
                    var tokenType: TokenType
                    repeat {
                        tokenType = TokenType.random()
                    } while (column >= 2 &&
                        tokens[column - 1, row]?.tokenType == tokenType &&
                        tokens[column - 2, row]?.tokenType == tokenType) ||
                        (row >= 2 &&
                            tokens[column, row - 1]?.tokenType == tokenType &&
                            tokens[column, row - 2]?.tokenType == tokenType)
                    
                    let token = Token(column: column, row: row, tokenType: tokenType)
                    tokens[column, row] = token
                    
                    set.insert(token)
                }
            }
        }
        return set
    }
    
    func performSwap(_ swap: Swap) {
        let columnA = swap.tokenA.column
        let rowA = swap.tokenA.row
        let columnB = swap.tokenB.column
        let rowB = swap.tokenB.row
        
        tokens[columnA, rowA] = swap.tokenB
        swap.tokenB.column = columnA
        swap.tokenB.row = rowA
        
        tokens[columnB, rowB] = swap.tokenA
        swap.tokenA.column = columnB
        swap.tokenA.row = rowB
    }
    
    fileprivate func hasChainAtColumn(_ column: Int, row: Int) -> Bool {
        let tokenType = tokens[column, row]!.tokenType
        
        var horzLength = 1
        
        //left
        var i = column - 1
        while i >= 0 && tokens[i, row]?.tokenType == tokenType {
            i -= 1
            horzLength += 1
        }
        
        //right
        i = column + 1
        while i < NumColumns && tokens[i, row]?.tokenType == tokenType {
            i += 1
            horzLength += 1
        }
        
        if horzLength >= 3 {return true}
        
        var vertLength = 1
        
        //down
        i = row - 1
        while i >= 0 && tokens[column, i]?.tokenType == tokenType {
            i -= 1
            vertLength += 1
        }
        
        //up
        i = row + 1
        while i < NumRows && tokens[column, i]?.tokenType == tokenType {
            i += 1
            vertLength += 1
        }
        
        if vertLength >= 3 {return true} else {return false}
        
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let token = tokens[column, row] {
                    if column < NumColumns - 1 {
                        if let other = tokens[column + 1, row] {
                            tokens[column, row] = other
                            tokens[column + 1, row] = token
                            
                            if hasChainAtColumn(column + 1, row: row) || hasChainAtColumn(column, row: row) {
                                set.insert(Swap(tokenA: token, tokenB: other))
                            }
                            
                            tokens[column, row] = token
                            tokens[column + 1, row] = other
                        }
                    }
                    
                    if row < NumRows - 1 {
                        if let other = tokens[column, row + 1] {
                            tokens[column, row] = other
                            tokens[column, row + 1] = token
                            
                            if hasChainAtColumn(column, row: row + 1) || hasChainAtColumn(column, row: row) {
                                set.insert(Swap(tokenA: token, tokenB: other))
                            }
                            
                            tokens[column, row] = token
                            tokens[column, row + 1] = other
                        }
                        
                    }
                }
            }
        }
        possibleSwaps = set
        if possibleSwaps.count == 0 {
            noSwaps = true
        } else {
            noSwaps = false
        }
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    fileprivate func detectHorizontalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for row in 0..<NumRows {
            var column = 0
            while column < NumColumns - 2 {
                if let token = tokens[column, row] {
                    let matchType = token.tokenType
                    
                    if tokens[column + 1, row]?.tokenType == matchType &&
                        tokens[column + 2, row]?.tokenType == matchType {
                        let chain = Chain(chainType: .horizontal)
                        repeat {
                            chain.addToken(tokens[column, row]!)
                            column += 1
                            
                        } while column < NumColumns && tokens[column, row]?.tokenType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        
        return set
    }
    
    fileprivate func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns {
            var row = 0
            while row < NumRows - 2 {
                if let token = tokens[column, row] {
                    let matchType = token.tokenType
                    
                    if tokens[column, row + 1]?.tokenType == matchType &&
                        tokens[column, row + 2]?.tokenType == matchType {
                        let chain = Chain(chainType: .vertical)
                        repeat {
                            chain.addToken(tokens[column, row]!)
                            row += 1
                        } while row < NumRows && tokens[column, row]?.tokenType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }

    fileprivate func detectSpecialMatches(_ horizontalChains: inout Set<Chain>, verticalChains: inout Set<Chain>) -> Set<Chain> {
        var set = Set<Chain>()
        var chainType: Chain.ChainType?
        
        
        for hchain in horizontalChains {
            for vchain in verticalChains {
                 if hchain.firstToken() == vchain.firstToken() ||
                    hchain.firstToken() == vchain.lastToken() ||
                    hchain.lastToken() == vchain.firstToken() ||
                    hchain.lastToken() == vchain.lastToken() {
                    chainType = Chain.ChainType.specialL
                 } else {
                    for htoken in hchain.tokens {
                        if vchain.tokens.contains(htoken) {
                            chainType = Chain.ChainType.specialT
                            break
                        }
                    }
                }
                if chainType != nil {
                    let newChain = Chain(chainType: chainType!)
                    for token in hchain.tokens {
                        newChain.addToken(token)
                    }
                    for token in vchain.tokens {
                        newChain.addToken(token)
                    }
                    horizontalChains.remove(hchain)
                    verticalChains.remove(vchain)
                    set.insert(newChain)
                }
            }
        }
        
        return set
    }
    
    func removeMatches(strength: Double, wave: Int) -> Set<Chain> {
        var horizontalChains = detectHorizontalMatches()
        var verticalChains = detectVerticalMatches()
        let specialChains = detectSpecialMatches(&horizontalChains, verticalChains: &verticalChains)
        
        processTokens(chains: horizontalChains)
        processTokens(chains: verticalChains)
        processTokens(chains: specialChains)
        
        calculateScores(horizontalChains, strength: strength, wave: wave)
        calculateScores(verticalChains, strength: strength, wave: wave)
        calculateScores(specialChains, strength: strength, wave: wave)
        
        return horizontalChains.union(verticalChains).union(specialChains)
    }
    
    fileprivate func processTokens(chains: Set<Chain>) {
        for chain in chains {
            for token in chain.tokens {
                switch token.status {
                case .Poison:
                    tokens[token.column, token.row] = nil
                case .Freeze:
                    // change status back to none, but do not remove from grid
                    tokens[token.column, token.row]!.status = .None
                default:
                    tokens[token.column, token.row] = nil
                }
            }
        }
    }
    
    func fillHoles() -> [[Token]] {
        var columns = [[Token]]()
        
        for column in 0..<NumColumns {
            var array = [Token]()
            for row in 0..<NumRows {
                if tiles[column, row] != nil && tokens[column, row] == nil {
                    for lookup in (row + 1)..<NumRows {
                        if let token = tokens[column, lookup] {
                            tokens[column, lookup] = nil
                            tokens[column, row] = token
                            token.row = row
                            array.append(token)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpTokens() -> [[Token]] {
        var columns = [[Token]]()
        var tokenType: TokenType = .unknown
        
        for column in 0..<NumColumns {
            var array = [Token]()
            
            var row = NumRows - 1
            while row >= 0 && tokens[column, row] == nil {
                if tiles[column, row] != nil {
                    var newTokenType: TokenType
                    repeat {
                        newTokenType = TokenType.random()
                    } while newTokenType == tokenType
                    tokenType = newTokenType
                    
                    let token = Token(column: column, row: row, tokenType: tokenType)
                    tokens[column, row] = token
                    array.append(token)
                }
                
                row -= 1
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    fileprivate func calculateScores(_ chains: Set<Chain>, strength: Double, wave: Int) {
        for chain in chains {
            chain.score = Int(round(Double(60 * (chain.length - 2) * comboMultiplier * chain.chainType.typeMultiplier) * strength / 10)) * 10
            if chain.firstToken().tokenType == monsters[wave].vulnerability {
                chain.score *= 2
            } else if chain.firstToken().tokenType == monsters[wave].resistance {
                chain.score = Int(round(Double(chain.score) * 0.5))
            }

            comboMultiplier += 1
        }
    }
    
    func resetComboMultiplier() {
        comboMultiplier = 1
    }
}


