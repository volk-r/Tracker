//
//  ShowPreview.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import SwiftUI

extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let vc: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController { vc }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }

    func showPreview() -> some View {
        Preview(vc: self).edgesIgnoringSafeArea(.all)
    }
}

extension UITableViewCell {
    private struct Preview: UIViewRepresentable {
        let tv: UITableViewCell
        typealias UIViewType = UITableViewCell

        func makeUIView(context: Context) ->  UITableViewCell { tv }
        func updateUIView(_ uiView: UITableViewCell, context: Context) { }
    }

    func showPreview() -> some View {
        Preview(tv: self).edgesIgnoringSafeArea(.all)
    }
}
