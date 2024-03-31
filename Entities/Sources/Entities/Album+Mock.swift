//
//  File.swift
//  
//
//  Created by Hong Seong Ho on 3/31/24.
//

import Foundation

extension Album {

    private static let fileInfo: [String: [String: [String]]] = [
        "Adele": ["30": ["1-02 Easy On Me"]],
        "Sia": [
            "1000 Forms Of Fear": ["1-01 Chandelier"],
            "Unstoppable": ["1-01 Unstoppable"]
        ],
        "The Weeknd": [
            "After Hours": ["1-13 After Hours"],
            "Starboy (Explicit Ver.)": [
                "1-01 Starboy (Feat. Daft Punk) (Explicit Ver.)",
                "1-14 Ordinary Life (Explicit Ver.)"
            ]
        ]
    ]

    public static var mockAlbumList: [Album] {
        var albums = [Album]()

        for (artist, albumDictonary) in fileInfo {
            for (albumTitle, musicNameList) in albumDictonary {
                var musicList = [Music]()

                for musicName in musicNameList {
                    if let url = Bundle.module.url(forResource: musicName, withExtension: "mp3") {
                        let music = Music(id: UUID(), title: musicName, artist: artist, assetURL: url)
                        musicList.append(music)
                    }
                }

                let album = Album(id: UUID(), title: albumTitle, artist: artist, musicList: musicList)
                albums.append(album)
            }
        }

        return albums
    }
}
