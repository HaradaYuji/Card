//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    // スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!

    // ユーザーカード1の情報
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var personName1: UILabel!
    @IBOutlet weak var personJob1: UILabel!
    @IBOutlet weak var personHome1: UILabel!
    @IBOutlet weak var personImage1: UIImageView!

    // ユーザーカード2の情報
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var personName2: UILabel!
    @IBOutlet weak var personJob2: UILabel!
    @IBOutlet weak var personHome2: UILabel!
    @IBOutlet weak var personImage2: UIImageView!

    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数
    var selectedCardCount: Int = 0

    // ユーザーリスト
    let nameList: [UserData]  = [
        UserData(name: "津田梅子",image: #imageLiteral(resourceName: "津田梅子"), job: "教師", home: "千葉", bgColor: #colorLiteral(red: 1, green: 0.814948995, blue: 0.8542565316, alpha: 1) ),UserData(name: "ジョージワシントン", image: #imageLiteral(resourceName: "ガリレオガリレイ"), job: "大統領", home: "アメリカ", bgColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
        UserData(name: "ガリレオガリレイ", image: #imageLiteral(resourceName: "ガリレオガリレイ"), job: "物理学者", home: "イタリア", bgColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        UserData(name: "板垣退助", image: #imageLiteral(resourceName: "板垣退助"), job: "議員", home: "高知", bgColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        UserData(name: "ジョン万次郎", image: #imageLiteral(resourceName: "ジョン万次郎"), job: "冒険家", home: "アメリカ", bgColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        ]


    
}

