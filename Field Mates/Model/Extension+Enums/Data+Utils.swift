//
//  Data+Utils.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import Foundation

extension Data {
    
    static func fileURL(for data: Data, fileExtension: String = "jpg") throws -> URL {
        // Create a unique file name in the temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString
        let fileURL = tempDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        
        // Write the data to the file
        try data.write(to: fileURL)
        
        return fileURL
    }
}
