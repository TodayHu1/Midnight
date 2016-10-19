//
//  Extensions.swift
//  MatchRPG
//
//  Created by David Garrett on 8/2/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(_ filename: String) -> [String: AnyObject]? {
        var dataOK: Data
        var dictionaryOK: NSDictionary = NSDictionary()
        
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            let _: NSError?
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
                dataOK = data!
            }
            catch{
                print("Could not load file: \(filename), error: \(error)")
                return nil
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dictionaryOK = (dictionary as! NSDictionary as? [String: AnyObject])! as NSDictionary
            }
            catch {
                print("File '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        else {
            print("Something went wrong")
        }
        return dictionaryOK as? [String: AnyObject]
    }
}
