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

enum RepositoryError: ErrorType {
    case NotASymlink
}

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
        let options: NSDirectoryEnumerationOptions = .SkipsHiddenFiles
        do {
            filelist = try self.fileManager.contentsOfDirectoryAtURL(path,
                includingPropertiesForKeys: ["NSURLIsDirectoryKey",
                                             "NSURLIsSymbolicLinkKey"],
            options: options)
        } catch {
            
        }
        return filelist
    }

    /**
        Return true if url is a directory.
    
        :param: path A NSURL instance to check.
    
        :returns: A boolean that is true if path exist and is a directory.
    */
    func urlIsDirectory(path: NSURL?) -> Bool {
        guard let path = path else {
            return false
        }
        var isDirectory: ObjCBool = false
        let exist = self.fileManager.fileExistsAtPath(path.path!, isDirectory: &isDirectory)
        if exist && isDirectory {
            return true
        } else {
            return false
        }
    }
    
    /**
        Return true if url is a symbolic link.

        :param: path A NSURL instance to check.

        :returns: A boolean that is true if path is a symlink
    */
    func urlIsSymlink(url: NSURL?) -> Bool {
        guard let unwrappedURL = url else {
            return false
        }
        guard let path = unwrappedURL.path else {
            return false
        }
        do {
            let attributes = try self.fileManager.attributesOfItemAtPath(path)
            if attributes["NSFileType"] as! String == NSFileTypeSymbolicLink {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /**
        Check if symbolic link has a existing target.

        The function expects the NSURL to be a symlink and and will raise otherwise.

        :param: path A NSURL instance to check.

        :returns: A boolen that is true if the link target exist and false if the link is broken.
    */
    func symlinkTargetExist(url: NSURL?) throws -> Bool {
        guard let unwrappedURL = url else {
            return false
        }
        guard let path = unwrappedURL.path else {
            return false
        }
        let attributes = try self.fileManager.attributesOfItemAtPath(path)
        if attributes["NSFileType"] as! String != NSFileTypeSymbolicLink {
            throw RepositoryError.NotASymlink
        }
        if fileManager.fileExistsAtPath(path) {
            return true
        } else {
            return false
        }
    }
}

class AnnexCmd {
    var cwd: String

    init(repoRoot: NSURL) {
        if let cwd = repoRoot.path {
            self.cwd = cwd
        } else {
            self.cwd = "/"
        }
    }

    /**
        Perform the git annex get command at the file located at the path of NSURL.
    */
    func get(url: NSURL) {
        guard (url.path != nil) else {
            return
        }
        let task = NSTask()
        task.currentDirectoryPath = self.cwd
        task.arguments = ["annex", "get", url.path!]
        task.launchPath = "/usr/local/bin/git"
        task.environment = ["PATH":"/usr/local/bin:/usr/bin"]
        print(task.environment)
        let out_pipe = NSPipe()
        let err_pipe = NSPipe()
        task.standardOutput = out_pipe
        task.standardError = err_pipe
        task.launch()
        print("Getting")
        task.waitUntilExit()
        print(NSString(data: out_pipe.fileHandleForReading.readDataToEndOfFile(), encoding: NSUTF8StringEncoding) )
        //print(err_pipe.fileHandleForReading)
        
    }
}