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

    // 「いいね」をされた名前の配列
    var likedName: [String] = []


    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }


    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }

    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理
            person.center = self.centerOfCard
            person.transform = .identity
        }
    }

    // ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }

    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {

        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        // likeImageの表示のコントロール
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }

        // 元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {

            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 左へ飛ばす場合
                    // X座標を左に500とばす(-500)
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // 次のカードへ
                selectedCardCount += 1

                if selectedCardCount >= personList.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねリストに追加
                likedName.append(nameList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                
                if selectedCardCount >= personList.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }

    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            // ベースカードをリセット
            self.resetCard()
            // ユーザーカードを左にとばす
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y:self.personList[self.selectedCardCount].center.y)
        })

        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        // いいねリストに追加
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }    /// ベースカードの中心
    var centerOfCard: CGPoint!
    /// ユーザーカードの配列
    var personList: [UIView] = []
    /// どちらビューを表示させるか
    var selectedCardCount: Int = 0
    /// 次に表示させるユーザーリストの番号
    var nextShowViewCount: Int = 2
    /// 現在表示させているユーザーリストの番号
    var showViewCount: Int = 0

    /// ユーザーリスト
    let userList: [UserData] = [
        UserData(name: "津田梅子", image: #imageLiteral(resourceName: "津田梅子"), job: "教師", homeTown: "千葉", backColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        UserData(name: "ジョージワシントン", image: #imageLiteral(resourceName: "ジョージワシントン"), job: "大統領", homeTown: "アメリカ", backColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        UserData(name: "ガリレオガリレイ", image: #imageLiteral(resourceName: "ガリレオガリレイ"), job: "物理学者", homeTown: "イタリア", backColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
        UserData(name: "板垣退助", image: #imageLiteral(resourceName: "板垣退助"), job: "議員", homeTown: "高知", backColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
        UserData(name: "ジョン万次郎", image: #imageLiteral(resourceName: "ジョン万次郎"), job: "冒険家", homeTown: "アメリカ", backColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
    ]

    /// 「いいね」をされた名前の配列
    var likedName: [String] = []

    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }

    // ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        personList.append(person1)
        personList.append(person2)

    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 行き先の確認
        if segue.identifier == "ToLikedList" {
            // 次のビューを代入
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        showViewCount = 0
        nextShowViewCount = 2
        // リスト初期化
        likedName = []

        // ビューを整理
        self.view.sendSubviewToBack(person2)
        // alpha値を元に戻す
        person1.alpha = 1
        person2.alpha = 1

        // 二枚のビューを初期化
        // 1枚目の人物を描画
        checkUserCard(showViewNumber: 0)

        // 描画対象を2枚目のビューに変更
        selectedCardCount = 1
        //2枚目の人物を描画
        checkUserCard(showViewNumber: 1)

        // カウントを元に戻す
        selectedCardCount = 0
    }

    /// ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }

    /// ユーザーカードを次に進める処理
    func nextUserView() {
        // 背面に持っていく
        self.view.sendSubviewToBack(personList[selectedCardCount])
        // 中央に戻す
        personList[selectedCardCount].center = centerOfCard
        personList[selectedCardCount].transform = .identity

        // ビューがすべての人物を描画し終わったら、ビューを真っ白にするようにする
        if nextShowViewCount < userList.count {
            checkUserCard(showViewNumber: nextShowViewCount)
        } else {
            // 背面のビューを見えなくする
            person2.alpha = 0
        }

        // 次のカードへ
        nextShowViewCount += 1
        showViewCount += 1

        if showViewCount >= userList.count {
            person1.alpha = 0
            // 遷移処理
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        selectedCardCount = showViewCount % 2
    }

    /**
     * 表示するビューを決めて、ユーザーカードを表示させる
     * - Parameters:
     *   - showViewNumber: 次に描画させたい人物の番号
     */
    func checkUserCard(showViewNumber: Int) {
        // 表示されているカードの名前を保管
        let user = userList[showViewNumber]
        // 表示するビューを管理する
        if selectedCardCount == 0 {
            // ビューの背景に色をつける
            person1.backgroundColor = user.backColor
            // ラベルに名前を表示
            personName1.text = user.name
            // ラベルに職業を表示
            personJob1.text = user.job
            // ラベルに出身地を表示
            personHome1.text = user.homeTown
            // 画像を表示
            personImage1.image = user.image
        } else {
            // ビューの背景に色をつける
            person2.backgroundColor = user.backColor
            // ラベルに名前を表示
            personName2.text = user.name
            // ラベルに職業を表示
            personJob2.text = user.job
            // ラベルに出身地を表示
            personHome2.text = user.homeTown
            // 画像を表示
            personImage2.image = user.image
        }
    }

    /// ユーザーカードを左右に飛ばす処理
    func farCard(distance: CGFloat, button: UIButton?) {
        UIView.animate(withDuration: 0.5, animations: {
            // ユーザーカードを左にとばす
            // X座標をdistance分飛ばす
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + distance, y :self.personList[self.selectedCardCount].center.y)
        })

        // ボタンかスワイプかを判断
        if button != nil {
            // ボタンを使えなくする(連打防止)
            button?.isEnabled = false
            // 0.5秒のdelayをかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.nextUserView()
                button?.isEnabled = true
            })

        } else {
            // 次の人物を写す
            nextUserView()
        }
        // ベースカードをリセット
        resetCard()
    }

    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        // likeImageの表示のコントロール
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }

        // 手を話した時の処理
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                farCard(distance: -500, button: nil)
                // likeImageを隠す
                likeImage.isHidden = true
            } else if card.center.x > self.view.frame.width - 50 {
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねリストに追加
                likedName.append(userList[showViewCount].name)
                // 右に大きくスワイプしたときの処理
                farCard(distance: 500, button: nil)
            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }

    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // カードを左に飛ばす
        farCard(distance: -500, button: sender)
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: UIButton) {
        sender.isEnabled = false
        // いいねリストに追加
        likedName.append(userList[showViewCount].name)
        // カードを右に飛ばす
        farCard(distance: 500, button: sender)
    }
}

