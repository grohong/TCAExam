//
//  MusicListViewPreviews.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import TCAExamEntities
import TCAExamViews

struct MusicListViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicListView(
            musicList: Album.mockAlbumList.first!.musicList,
            tapAction: { _ in }
        )
            .previewLayout(.fixed(width: 375, height: 300))
    }
}
