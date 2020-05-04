//
//  FileManager+Extensions.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 10/04/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension FileManager {
    
    /// Calculate the allocated size of a directory and all its contents on the volume.
    ///
    /// As there's no simple way to get this information from the file system the method
    /// has to crawl the entire hierarchy, accumulating the overall sum on the way.
    /// The resulting value is roughly equivalent with the amount of bytes
    /// that would become available on the volume if the directory would be deleted.
    func sizeOfDirectory(at directoryURL: URL) throws -> UInt64 {
        
        // The error handler simply stores the error and stops traversal
        var enumeratorError: Error? = nil
        func errorHandler(_: URL, error: Error) -> Bool {
            enumeratorError = error
            return false
        }
        
        let enumerator = self.enumerator(at: directoryURL,
                                         includingPropertiesForKeys: Array(fileSizeResourceKeys),
                                         options: [],
                                         errorHandler: errorHandler)!
        
        var accumulatedSize: UInt64 = 0
        
        for item in enumerator {
            
            // Bail out on errors from the errorHandler.
            if enumeratorError != nil { break }
            
            // Add up individual file sizes.
            let contentItemURL = item as! URL
            accumulatedSize += try contentItemURL.regularFileAllocatedSize()
        }
        
        // Rethrow errors from errorHandler.
        if let error = enumeratorError { throw error }
        
        return accumulatedSize
    }
}

fileprivate let fileSizeResourceKeys: Set<URLResourceKey> = [
    .isRegularFileKey,
    .totalFileSizeKey,
    .fileSizeKey
]

fileprivate extension URL {
    
    func regularFileAllocatedSize() throws -> UInt64 {
        let resourceValues = try self.resourceValues(forKeys: fileSizeResourceKeys)
        
        // We only look at regular files.
        guard resourceValues.isRegularFile ?? false else {
            return 0
        }
        
        return UInt64(resourceValues.totalFileSize ?? resourceValues.fileSize ?? 0)
    }
}
