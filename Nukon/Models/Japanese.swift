//
//  Japanese.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import Foundation

struct Japanese {
    var select: Bool
    let sound: String
    let letters: [String]
//    let hiragana: [String]?
}

enum JapaneseType: String {
    case hiragana = "hiragana"
    case katakana = "katakana"
    case voicedHiragana = "voiced-hiragana"
    case voicedKatakana = "voiced-katakana"
}
