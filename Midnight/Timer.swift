//
//  Timer.swift
//  MatchRPG
//
//  Created by David Garrett on 9/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

/// Represents a timer that can be used with Sprite Kit
final public class Timer {
    
    fileprivate(set) public var dt:CFTimeInterval = 0
    
    
    fileprivate var previousTime:CFTimeInterval = CFAbsoluteTimeGetCurrent() // needs to be this
    fileprivate var shouldCorrectAfterPause = false
    
    /// pause the timer
    public func pause() {
        advance(CFAbsoluteTimeGetCurrent())
        shouldCorrectAfterPause = true
    }
    
    /// unpause the timer
    /// must be called after calling pause to resume
    /// the timer's ability to calculate elapsed time
    /// properly
    public func unpause() {
        advance(CFAbsoluteTimeGetCurrent())
        shouldCorrectAfterPause = false
    }
    
    /// advance the timer's elapsed time by the timestep
    /// of the game loop
    public func advance(_ paused:Bool = false) {
        advance(CFAbsoluteTimeGetCurrent())
    }
    
    fileprivate func advance(_ currentTime:CFTimeInterval) {
        if shouldCorrectAfterPause {
            dt = 0
            previousTime = currentTime
        }
        else  {
            dt = currentTime - previousTime
            previousTime = currentTime
        }
    }
}
