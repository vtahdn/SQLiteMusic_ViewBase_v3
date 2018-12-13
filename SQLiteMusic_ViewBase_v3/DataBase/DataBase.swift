//
//  DataBase.swift
//  SQLiteMusic_ViewBase_v3
//
//  Created by Viet Asc on 12/13/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import Foundation

class DataBase {
    
    // DataBase Path
    var path = { () -> String in
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = NSString(string: dirPaths[0])
        return docsDir.appendingPathComponent("music.db")
        
    }
    
    // Init a Database
    var dataBase = { (_ path: String) -> Bool in
        
        let file = FileManager.default
        if !file.fileExists(atPath: path) {
            if let musicDB = FMDatabase(path: path) {
                if musicDB.open() {
                    let songQuery = "create table if not exists SONGS (ID integer primary key autoincrement, SongName text, UrlImg text)"
                    let detailPlayListQuery = "create table if not exists DetailPlayList (SongID integer, PlayListID integer, foreign key (PlayListID) references PLAYLIST(ID), foreign key (SongID) references SONG(ID), primary key (SongID, PlayListID))"
                    let playListQuery = "create table if not exists PLAYLIST (ID integer primary key autoincrement, PlaylistName text)"
                    let albumsQuery = "create table if not exists ALBUMS (ID integer primary key autoincrement, Price text, AlbumName text, ReleaseDate text, UrlImg text)"
                    let detailAlbumQuery = "create table if not exists DETAILALBUM (AlbumID integer, " +
                    "GenderID integer, " +
                    "ArtistID integer, " +
                    "SongID integer, " +
                    "foreign key (AlbumID) references ALBUMS(ID), " +
                    "foreign key (GenderID) references GENDER(ID), " +
                    "foreign key (ArtistID) references ARTISTS(ID), " +
                    "foreign key (SongID) references SONGS(ID), " +
                    "primary key (AlbumID, GenderID, ArtistID, SongID)"
                    let artistQuery = "create table if not exists ARTISTS (ID integer primary key autoincrement, ArtistName text, UrlImg text, Born text not null)"
                    let genderQuery = "create table if not exists GENDER (ID integer primary key autoincrement, GenderName text)"
                    if !musicDB.executeStatements(songQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(detailPlayListQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(playListQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(albumsQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(detailAlbumQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(artistQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    if !musicDB.executeStatements(genderQuery) {
                        print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                    }
                    musicDB.close()
                    return true
                } else {
                      print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                }
            }
        }
        return false
        
    }
    
    var insert = { (_ nameTable: String, _ dict: NSDictionary, _ path: String) in
        
        var keys = String()
        var values = String()
        var first = true
        for key in dict.allKeys {
            if first {
                keys = "'" + (key as! String) + "'"
                values = "'" + (dict.object(forKey: key) as! String) + "'"
                first = false
                continue
            }
            keys = keys + "," + "'" + (key as! String) + "'"
            values = values + "," + "'" + (dict.object(forKey: key) as! String) + "'"
        }
        
        if let musicDB = FMDatabase(path: path) {
            if musicDB.open() {
                if (!musicDB.executeStatements("PRAGMA foreign_keys = ON")) {
                    print("Error: \(String(describing: musicDB.lastErrorMessage()))")
                }
            }
            let insertQuery = "insert into \(nameTable) (\(keys)) values (\(values))"
            let result = musicDB.executeUpdate(insertQuery, withArgumentsIn: nil)
            if !result {
                 print("Error: \(String(describing: musicDB.lastErrorMessage()))")
            }
            musicDB.close()
        }
        
    }
    
    var view = { (_ tableName: String, _ columns: [String], _ statement: String, _ path: String) -> [NSDictionary] in
        
        var items = [NSDictionary]()
        if let musicDB = FMDatabase(path: path) {
            if musicDB.open() {
                var allColumns = ""
                for column in columns {
                    if allColumns == "" {
                        allColumns = column
                    } else {
                        allColumns = allColumns + "," + column
                    }
                }
                let selectQuery = "select distinct \(allColumns) from \(tableName) \(statement)"
                let results: FMResultSet?
                do {
                    results = try musicDB.executeQuery(selectQuery, values: nil)
                    while (results?.next())! {
                        items.append((results?.resultDictionary()! as NSDictionary?)!)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
            }
            musicDB.close()
        }
        return items
        
    }
    
    init() {
        let path = self.path()
        dataBase(path)
        insert("ALBUMS", ["Price":"200.000", "AlbumName":"Anh Bỏ Thuốc Em Sẽ Yêu", "ReleaseDate":"11/1/2015", "UrlImg":"Anh Bỏ Thuốc Em Sẽ Yêu - Lyna Thuỳ Linh.jpg"], path)
        print(view("ALBUMS", ["*"], "", path))
    }
    
}
