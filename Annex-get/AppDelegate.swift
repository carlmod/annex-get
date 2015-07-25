//
//  AppDelegate.swift
//  Annex-get
//
//  Created by Carl Moden on 2015-07-21.
//  Copyright © 2015 Carl Moden. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AppKit
import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSBrowserDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var annexBrowser: NSBrowser!

    @IBOutlet weak var getButton: NSToolbarItem!
    @IBOutlet weak var dropButton: NSToolbarItem!
    @IBOutlet weak var dropAllButton: NSToolbarItem!

    let repo = Repository()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        annexBrowser.delegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func browser(sender: NSBrowser, willDisplayCell cell: AnyObject, atRow row: Int, column: Int) {
        let browserCell = cell as! NSBrowserCell
        let browserPath = sender.pathToColumn(column)
        let fullPath = self.repo.repoRoot.URLByAppendingPathComponent(browserPath)
        browserCell.stringValue = self.repo.listFiles(fullPath)[row].lastPathComponent!
    }
    
    func browser(sender: NSBrowser, numberOfRowsInColumn column: Int) -> Int {
        let browserPath = sender.pathToColumn(column)
        let fullPath = self.repo.repoRoot.URLByAppendingPathComponent(browserPath)
        let numRows = self.repo.listFiles(fullPath).count
        return numRows
    }
    
    @IBAction func browserAction(sender: NSBrowser) {
        print(sender.path())
    }

    @IBAction func getAction(sender: AnyObject) {
    }

    @IBAction func dropAction(sender: AnyObject) {
    }
    
    @IBAction func dropAllAction(sender: AnyObject) {
    }
}

