//
//  CharacterProfilePageController.swift
//  Midnight
//
//  Created by David Garrett on 10/31/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterProfilePageController : UIPageViewController {
    var savedGame: GameSave!
    var characterArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCharacterArray()
        dataSource = self
        
        self.view.backgroundColor = UIColor.lightGray
        
        let pc = UIPageControl.appearance()
        pc.currentPageIndicatorTintColor = UIColor.purple
        pc.pageIndicatorTintColor = UIColor.white
        
        setViewControllers([characterViewControllerAtIndex(pageIndex: 1)], direction: .forward, animated: true, completion: nil)
    }
    
    func loadCharacterArray() {
        for (key, _) in savedGame.characters {
            characterArray.append(key)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
}

extension CharacterProfilePageController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = (viewController as! CharacterProfileViewController).pageIndex + 1
        if pageIndex > characterArray.count {
            return nil
        } else {
            return characterViewControllerAtIndex(pageIndex: pageIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = (viewController as! CharacterProfileViewController).pageIndex - 1
        if pageIndex == 0 {
            return nil
        } else {
            return characterViewControllerAtIndex(pageIndex: pageIndex)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return savedGame.characters.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func characterViewControllerAtIndex(pageIndex: Int) -> UIViewController {
        let characterView = self.storyboard?.instantiateViewController(withIdentifier: "characterProfile") as! CharacterProfileViewController
        characterView.character = savedGame.characters[characterArray[pageIndex-1]]
        characterView.pageIndex = pageIndex
        
        return characterView
    }
}
