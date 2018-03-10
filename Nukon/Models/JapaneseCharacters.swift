//
//  JapaneseCharacters.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/04.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import Foundation

struct JapaneseCharacters {
    static let instance = JapaneseCharacters()
    let hiraganaList = [
        Japanese(unLockNext: false, sound: "Vowel", letters: ["あ", "い", "う", "え", "お"]),
        Japanese(unLockNext: false, sound: "K", letters: ["か", "き", "く", "け", "こ"]),
        Japanese(unLockNext: false, sound: "S", letters: ["さ", "し", "す", "せ", "そ"]),
        Japanese(unLockNext: false, sound: "T", letters: ["た", "ち", "つ", "て", "と"]),
        Japanese(unLockNext: false, sound: "N", letters: ["な", "に", "ぬ", "ね", "の"]),
        Japanese(unLockNext: false, sound: "Special-N", letters: ["ん"]),
        Japanese(unLockNext: false, sound: "H", letters: ["は", "ひ", "ふ", "へ", "ほ"]),
        Japanese(unLockNext: false, sound: "M", letters: ["ま", "み", "む", "め", "も"]),
        Japanese(unLockNext: false, sound: "Y", letters: ["や", "ゆ", "よ"]),
        Japanese(unLockNext: false, sound: "R", letters: ["ら", "り", "る", "れ", "ろ"]),
        Japanese(unLockNext: false, sound: "W", letters: ["わ", "を"]),
        Japanese(unLockNext: false, sound: "G", letters: ["が", "ぎ", "ぐ", "げ", "ご"]),
        Japanese(unLockNext: false, sound: "Z", letters: ["ざ", "じ", "ず", "ぜ", "ぞ"]),
        Japanese(unLockNext: false, sound: "D", letters: ["だ", "ぢ", "づ", "で", "ど"]),
        Japanese(unLockNext: false, sound: "B", letters: ["ば", "び", "ぶ", "べ", "ぼ"]),
        Japanese(unLockNext: false, sound: "P", letters: ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ"])
    ]
    
    let katakanaList = [
        Japanese(unLockNext: false, sound: "Vowel", letters: ["ア", "イ", "ウ", "エ", "オ"]),
        Japanese(unLockNext: false, sound: "K", letters: ["カ", "キ", "ク", "ケ", "コ"]),
        Japanese(unLockNext: false, sound: "S", letters: ["サ", "シ", "ス", "セ", "ソ"]),
        Japanese(unLockNext: false, sound: "T", letters: ["タ", "チ", "ツ", "テ", "ト"]),
        Japanese(unLockNext: false, sound: "N", letters: ["ナ", "ニ", "ヌ", "ネ", "ノ"]),
        Japanese(unLockNext: false, sound: "Special-N", letters: ["ン"]),
        Japanese(unLockNext: false, sound: "H", letters: ["ハ", "ヒ", "フ", "ヘ", "ホ"]),
        Japanese(unLockNext: false, sound: "M", letters: ["マ", "ミ", "ム", "メ", "モ"]),
        Japanese(unLockNext: false, sound: "Y", letters: ["ヤ", "ユ", "ヨ"]),
        Japanese(unLockNext: false, sound: "R", letters: ["ラ", "リ", "ル", "レ", "ロ"]),
        Japanese(unLockNext: false, sound: "W", letters: ["ワ", "ヲ"]),
        Japanese(unLockNext: false, sound: "G", letters: ["ガ", "ギ", "グ", "ゲ", "ゴ"]),
        Japanese(unLockNext: false, sound: "Z", letters: ["ザ", "ジ", "ズ", "ゼ", "ゾ"]),
        Japanese(unLockNext: false, sound: "D", letters: ["ダ", "ヂ", "ヅ", "デ", "ド"]),
        Japanese(unLockNext: false, sound: "B", letters: ["バ", "ビ", "ブ", "ベ", "ボ"]),
        Japanese(unLockNext: false, sound: "P", letters: ["パ", "ピ", "プ", "ペ", "ポ"])
    ]
    
    let yVowelHiraganaList = [
        Japanese(unLockNext: false, sound: "Ky", letters: ["きゃ", "きゅ", "きょ"]),
        Japanese(unLockNext: false, sound: "Sy", letters: ["しゃ", "しゅ", "しょ"]),
        Japanese(unLockNext: false, sound: "Ch", letters: ["ちゃ", "ちゅ", "ちょ"]),
        Japanese(unLockNext: false, sound: "Ny", letters: ["にゃ", "にゅ", "にょ"]),
        Japanese(unLockNext: false, sound: "Hy", letters: ["ひゃ", "ひゅ", "ひょ"]),
        Japanese(unLockNext: false, sound: "My", letters: ["みゃ", "みゅ", "みょ"]),
        Japanese(unLockNext: false, sound: "Ry", letters: ["りゃ", "りゅ", "りょ"]),
        Japanese(unLockNext: false, sound: "Gy", letters: ["ぎゃ", "ぎゅ", "ぎょ"]),
        Japanese(unLockNext: false, sound: "J", letters: ["じゃ", "じゅ", "じょ"]),
        //Japanese(unLockNext: false, sound: "Dy", letters: ["ぢゃ", "ぢゅ", "ぢょ"]),
        Japanese(unLockNext: false, sound: "By", letters: ["びゃ", "びゅ", "びょ"]),
        Japanese(unLockNext: false, sound: "Py", letters: ["ぴゃ", "ぴゅ", "ぴょ"])
    ]
    
    let yVowelKatakanaList = [
        Japanese(unLockNext: false, sound: "Ky", letters: ["キャ", "キュ", "キョ"]),
        Japanese(unLockNext: false, sound: "Sy", letters: ["シャ", "シュ", "ショ"]),
        Japanese(unLockNext: false, sound: "Cy", letters: ["チャ", "チュ", "チョ"]),
        Japanese(unLockNext: false, sound: "Ny", letters: ["ニャ", "ニュ", "ニョ"]),
        Japanese(unLockNext: false, sound: "Hy", letters: ["ヒャ", "ヒュ", "ヒョ"]),
        Japanese(unLockNext: false, sound: "My", letters: ["ミャ", "ミュ", "ミョ"]),
        Japanese(unLockNext: false, sound: "Ry", letters: ["リャ", "リュ", "リョ"]),
        Japanese(unLockNext: false, sound: "Gy", letters: ["ギャ", "ギュ", "ギョ"]),
        Japanese(unLockNext: false, sound: "J", letters: ["ジャ", "ジュ", "ジョ"]),
        //Japanese(unLockNext: false, sound: "Dy", letters: ["ヂャ", "ヂュ", "ヂョ"]),
        Japanese(unLockNext: false, sound: "By", letters: ["ビャ", "ビュ", "ビョ"]),
        Japanese(unLockNext: false, sound: "Py", letters: ["ピャ", "ピュ", "ピョ"])
    ]
    
    let vowelSounds = ["a", "i", "u", "e", "o"]
    
    let soundsList = ["Vowel": ["a", "i", "u", "e", "o"],
                      "K": ["ka", "ki", "ku", "ke", "ko"],
                      "S": ["sa", "si", "su", "se", "so"],
                      "T": ["ta", "ti", "tu", "te", "to"],
                      "N": ["na", "ni", "nu", "ne", "no"],
                      "Special-N": ["n"],
                      "H": ["ha", "hi", "hu", "he", "ho"],
                      "M": ["ma", "mi", "mu", "me", "mo"],
                      "Y": ["ya", "yu", "yo"],
                      "R": ["ra", "ri", "ru", "re", "ro"],
                      "W": ["wa", "wo"],
                      "G": ["ga", "gi", "gu", "ge", "go"],
                      "Z": ["za", "zi", "zu", "ze", "zo"],
                      "D": ["da", "di", "du", "de", "do"],
                      "B": ["ba", "bi", "bu", "be", "bo"],
                      "P": ["pa", "pi", "pu", "pe", "po"],
                      "Ky": ["kya", "kyu", "kyo"],
                      "Sy": ["sya", "syu", "syo"],
                      "Cy": ["cya", "cyu", "cyo"],
                      "Ny": ["nya", "nyu", "nyo"],
                      "Hy": ["hya", "hyu", "hyo"],
                      "My": ["mya", "myu", "myo"],
                      "Ry": ["rya", "ryu", "ryo"],
                      "Gy": ["gya", "gyu", "gyo"],
                      "J": ["ja", "ju", "jo"],
                      "By": ["bya", "byu", "byo"],
                      "Py": ["pya", "pyu", "pyo"]]
}
