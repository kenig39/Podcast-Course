//
//  String.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 28.12.2022.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self :
        self.replacingOccurrences(of: "http", with: "https")
    }
}
