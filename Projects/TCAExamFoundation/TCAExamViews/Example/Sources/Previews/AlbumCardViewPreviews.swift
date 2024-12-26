//
//  AlbumCardViewPreviews.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import SharedMock
import TCAExamEntities
import TCAExamViews

struct AlbumCardViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumCardView(album: Album.mockAlbumList.first!)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
