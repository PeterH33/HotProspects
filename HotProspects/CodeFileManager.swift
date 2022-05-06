//
//  FileManagerDecode.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/16/22.
//

import Foundation

import SwiftUI

//This extension is for the storing and retrieving of data in the Documents directory of a program via json
extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //example call ** let test: String? = FileManager.default.decode("Message.txt") **
    func decode<T: Codable>(_ fromFile: String) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(fromFile)
        let decoder = JSONDecoder()
        
        do {
            let savedData = try Data(contentsOf: url)
            do {
                let decodedData = try decoder.decode(T.self, from: savedData)
                print("****  Decode Success")
                return decodedData
            } catch {
                print(error.localizedDescription)
                print("***** Decoding Failed!")
            }
        } catch {
            print(error.localizedDescription)
            print("**** Read Failed!")
        }
        return nil
    }
    
    //example call FileManager.default.encode(yourData, tofile: yourFileNameString)
    func encode<T: Codable>(_ data: T, toFile fileName: String) {
        let encoder = JSONEncoder()
        
        do {
            let encoded = try encoder.encode(data)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try encoded.write(to: url)
                print("**** Write Success \(url)")
            } catch {
                print(error.localizedDescription)
                print("**** Write Failed!")
            }
        } catch {
            print(error.localizedDescription)
            print("**** Encoding Failed!")
        }
    }
}
