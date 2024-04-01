//
//  SystemVolumeControlView.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import MediaPlayer

public struct SystemVolumeControlView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsVolumeSlider = true

        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(volumeView)
        volumeView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            volumeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            volumeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            volumeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            volumeView.heightAnchor.constraint(equalToConstant: 31)
        ])

        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) { }
}

struct SystemVolumeControlViewPreviews: PreviewProvider {
    static var previews: some View {
        SystemVolumeControlView()
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
