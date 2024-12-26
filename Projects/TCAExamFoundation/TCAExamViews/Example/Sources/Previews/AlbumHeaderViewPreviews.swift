//
//  AlbumHeaderViewPreviews.swift
//  
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import TCAExamEntities
import TCAExamViews

struct AlbumHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumHeaderView(album: Album.mockAlbumList.first!)
            .previewLayout(.fixed(width: 375, height: 150))
    }
}
