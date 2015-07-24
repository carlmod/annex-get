//
//  AppDelegate.swift
//  Annex-get
//
//  Created by Carl Moden on 2015-07-21.
//  Copyright © 2015 Carl Moden. All rights reserved.
//

import AppKit
import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSBrowserDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var annexBrowser: NSBrowser!



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        annexBrowser.delegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func browser(sender: NSBrowser, willDisplayCell cell: AnyObject, atRow row: Int, column: Int) {
        let browserCell = cell as! NSBrowserCell
        browserCell.stringValue = "AAA"
    }
    
    func browser(sender: NSBrowser, numberOfRowsInColumn column: Int) -> Int {
        let numRows=column + 1
        return numRows
    }

}

