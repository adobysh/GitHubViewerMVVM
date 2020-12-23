//
//  ArrayExtension.swift
//  GitHubViewerMVVM
//
//  Created by Andrei Dobysh on 24.12.20.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
