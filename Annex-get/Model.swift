//
//  Model.swift
//  Annex-get
//
//  Created by Carl Moden on 2015-07-24.
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

import Foundation

class Repository {
    let fileManager = NSFileManager.defaultManager()
    var repoRoot: NSURL
    
    init() {
        // For now we hardcode ~/Movies/Movies where my movie repo happens to
        // be located.
        // TODO: Make a resonable setup for this.
        let homeFolder = self.fileManager.URLsForDirectory(.MoviesDirectory, inDomains: .UserDomainMask)[0]
        self.repoRoot = homeFolder.URLByAppendingPathComponent("Movies/")
    }
    
    func listFiles(path: NSURL) -> [NSURL] {
        var filelist = [NSURL]()
        do {
            filelist = try self.fileManager.contentsOfDirectoryAtURL(path,
                includingPropertiesForKeys: ["NSURLIsDirectoryKey",
                                             "NSURLIsSymbolicLinkKey"],
            options: NSDirectoryEnumerationOptions())
        } catch {
            
        }
        return filelist
    }
    
}