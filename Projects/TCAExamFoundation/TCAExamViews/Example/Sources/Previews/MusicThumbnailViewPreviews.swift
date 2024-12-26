//
//  MusicThumbnailViewPreviews.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import AVFoundation
import TCAExamShared
import TCAExamEntities
import TCAExamViews

struct MusicThumbnailViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicThumbnailView(Album.mockAlbumList.first!.musicList.first!.asset)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
