//
//  JapaneseCharacters.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/04.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import Foundation

struct JapaneseCharacters {
    var hiraganaList = [
        Japanese(select: false, sound: "vowel", letters: ["あ", "い", "う", "え", "お", "　"]),
        Japanese(select: false, sound: "K", letters: ["か", "き", "く", "け", "こ", "　"]),
        Japanese(select: false, sound: "S", letters: ["さ", "し", "す", "せ", "そ", "　"]),
        Japanese(select: false, sound: "T", letters: ["た", "ち", "つ", "て", "と", "　"]),
        Japanese(select: false, sound: "N", letters: ["な", "に", "ぬ", "ね", "の", "ん"]),
        Japanese(select: false, sound: "H", letters: ["は", "ひ", "ふ", "へ", "ほ", "　"]),
        Japanese(select: false, sound: "M", letters: ["ま", "み", "む", "め", "も", "　"]),
        Japanese(select: false, sound: "Y", letters: ["や", "　", "ゆ","　", "よ", "　"]),
        Japanese(select: false, sound: "R", letters: ["ら", "り", "る", "れ", "ろ", "　"]),
        Japanese(select: false, sound: "W", letters: ["わ", "　", "　", "　", "を", "　"])
    ]
    
    var katakanaList = [
        Japanese(select: false, sound: "vowel", letters: ["ア", "イ", "ウ", "エ", "オ", "　"]),
        Japanese(select: false, sound: "K", letters: ["カ", "キ", "ク", "ケ", "コ", "　"]),
        Japanese(select: false, sound: "S", letters: ["サ", "シ", "ス", "セ", "ソ", "　"]),
        Japanese(select: false, sound: "T", letters: ["タ", "チ", "ツ", "テ", "ト", "　"]),
        Japanese(select: false, sound: "N", letters: ["ナ", "ニ", "ヌ", "ネ", "ノ", "ン"]),
        Japanese(select: false, sound: "H", letters: ["ハ", "ヒ", "フ", "ヘ", "ホ", "　"]),
        Japanese(select: false, sound: "M", letters: ["マ", "ミ", "ム", "メ", "モ", "　"]),
        Japanese(select: false, sound: "Y", letters: ["ヤ", "　", "ユ","　", "ヨ", "　"]),
        Japanese(select: false, sound: "R", letters: ["ラ", "リ", "ル", "レ", "ロ", "　"]),
        Japanese(select: false, sound: "W", letters: ["ワ", "　", "　", "　", "ヲ", "　"])
    ]
    
    var voicedHiraganaList = [
        Japanese(select: false, sound: "G", letters: ["が", "ぎ", "ぐ", "げ", "ご", "　"]),
        Japanese(select: false, sound: "Z", letters: ["ざ", "じ", "ず", "ぜ", "ぞ", "　"]),
        Japanese(select: false, sound: "D", letters: ["だ", "ぢ", "づ", "で", "ど", "　"]),
        Japanese(select: false, sound: "B", letters: ["ば", "び", "ぶ", "べ", "ぼ", "　"]),
        Japanese(select: false, sound: "P", letters: ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ", "　"])
    ]
    
    var voicedKatakanaList = [
        Japanese(select: false, sound: "G", letters: ["ガ", "ギ", "グ", "ゲ", "ゴ", "　"]),
        Japanese(select: false, sound: "Z", letters: ["ザ", "ジ", "ズ", "ゼ", "ゾ", "　"]),
        Japanese(select: false, sound: "D", letters: ["ダ", "ヂ", "ヅ", "デ", "ド", "　"]),
        Japanese(select: false, sound: "B", letters: ["バ", "ビ", "ブ", "ベ", "ボ", "　"]),
        Japanese(select: false, sound: "P", letters: ["パ", "ピ", "プ", "ペ", "ポ", "　"])
    ]
    
    
    var vowelSounds = ["a", "i", "u", "e", "o", " "]
}
