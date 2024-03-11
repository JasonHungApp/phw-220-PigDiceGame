//
//  ViewController.swift
//  phw-220-PigDiceGame
//
//  Created by jasonhung on 2024/3/9.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dieImageView: UIImageView!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var player1View: UIView!
    @IBOutlet weak var player2View: UIView!
    
    @IBOutlet weak var player1ActiveImageView: UIImageView!
    @IBOutlet weak var player2ActiveImageView: UIImageView!
    
    @IBOutlet weak var player1ScoreFrameView: UIView!
    @IBOutlet weak var player2ScoreFrameView: UIView!
    @IBOutlet weak var player1RoundScoreProgressView: UIView!
    @IBOutlet weak var player1ScoreProgressView: UIView!
    @IBOutlet weak var player2RoundScoreProgressView: UIView!
    @IBOutlet weak var player2ScoreProgressView: UIView!
    
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player1WinsLabel: UILabel!
    @IBOutlet weak var player2WinsLabel: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var roundNoLabel: UILabel!
    
    @IBOutlet weak var playView: UIView!
    
    
    // MARK: - Properties
    private var scores = [0, 0]
    private var roundScore = 0
    private var activePlayer: Player = .player1
    private let gameScore = 100
    private var wins = [0, 0]
    private var roundNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        player1View.layer.cornerRadius = 15
        player2View.layer.cornerRadius = 15
        roundView.layer.cornerRadius = 15
        playView.layer.cornerRadius = 15
        
        updatePlayerUI()
        updateWinsLabels()
        updateRoundInfo()
    }
    
    // MARK: - IBAction
    @IBAction func roll(_ sender: UIButton) {
        
        // 生成一個隨機的 Dice case
        let randomDice = Dice.allCases.randomElement()!
        
        // 獲取相應的 SF Symbol 名稱
        let sfSymbolName = randomDice.rawValue
        
        // 取得骰子的點數
        //let point = randomDice.getPoint()
        let point = randomDice.point
        
        // 設定 UIImageView 的 SF Symbol、點數和動畫效果
        setDieImageView(dieImageView, with: sfSymbolName)
        
        
        // 根據骰子點數更新分數
        if point != 1 {
            roundScore += point
            currentScoreLabel.text = String(roundScore)
        } else {
            // 如果擲出1點, 顯示警告視窗
            showAlertForRollOne()
            
            //當前回合結束,切換到下一個玩家
            roundScore = 0
            activePlayer = (activePlayer == .player1) ? .player2 : .player1
            
            updateRoundInfo()
            
        }
        updatePlayerUI()
        
    }
    
    
    //結算本局分數
    @IBAction func hold(_ sender: UIButton) {
        
        scores[activePlayer.rawValue] += roundScore
        updateScoreLabels()
        
        if scores[activePlayer.rawValue] >= gameScore {
            showWinnerAlert(activePlayer.rawValue)
            wins[activePlayer.rawValue] += 1
            updateWinsLabels()
            //resetGame()
        } else {
            roundScore = 0
            activePlayer = (activePlayer == .player1) ? .player2 : .player1
            updatePlayerUI()
            updateRoundInfo()
        }
        
        
    }
    
    // MARK: - updateUI
    
    
    func resetGame() {
        scores = [0, 0]
        roundScore = 0
        activePlayer = .player1 // 重設為第一位玩家
        roundNo = 0
        updateRoundInfo()
        updatePlayerUI()
    }

    
    func updatePlayerUI() {
        
        
        // 更新玩家分數標籤
        player1ScoreLabel.text = String(scores[0])
        player2ScoreLabel.text = String(scores[1])
        
        //更新進度條
        updateProgressViews()
        
        // 重置當前回合分數標籤和骰子圖片
        currentScoreLabel.text = "\(roundScore)"
        //dieImageView.image = nil
        
        // 使用不同的背景顏色來區分當前玩家
        player1View.backgroundColor = (activePlayer == .player1) ? .yellow : .white.withAlphaComponent(0.9)
        player2View.backgroundColor = (activePlayer == .player2) ? .yellow : .white.withAlphaComponent(0.9)
        player1ActiveImageView.isHidden = (activePlayer == .player1) ? false : true
        player2ActiveImageView.isHidden = (activePlayer == .player2) ? false : true
        
        
        

        
    }
    
    func updateRoundInfo(){
        // 更新局數
        roundNo = (activePlayer == .player1) ? roundNo + 1 : roundNo
        roundNoLabel.text = "\(wins[0] + wins[1] + 1)-\(roundNo)"
    }
    
    func updateProgressViews() {
        // 玩家總分數進度條
        player1ScoreProgressView.frame.size.width = player1ScoreFrameView.frame.width * CGFloat(scores[0]) / CGFloat(gameScore)
        player2ScoreProgressView.frame.size.width = player2ScoreFrameView.frame.width * CGFloat(scores[1]) / CGFloat(gameScore)
        
        // 當前回合分數進度條
        player1RoundScoreProgressView.frame.size.width = 0 // 玩家1的回合分數歸零
        player2RoundScoreProgressView.frame.size.width = 0 // 玩家2的回合分數歸零
        
        if activePlayer == .player1 {
            player1RoundScoreProgressView.frame.size.width = player1ScoreFrameView.frame.width * CGFloat(scores[0]+roundScore) / CGFloat(gameScore)
        }else{
            player2RoundScoreProgressView.frame.size.width = player2ScoreFrameView.frame.width * CGFloat(scores[1]+roundScore) / CGFloat(gameScore)
        }
        
        
    }
    
    
    func updateScoreLabels() {
        player1ScoreLabel.text = String(scores[0])
        player2ScoreLabel.text = String(scores[1])
    }
   
    
    func updateWinsLabels() {
        player1WinsLabel.text = "\(wins[0])"
        player2WinsLabel.text = "\(wins[1])"
    }
    
    // MARK: - Alert
    
    func showAlertForRollOne() {
        let alert = UIAlertController(title: "Turn Over", message: "You rolled a 1, your turn ends\nand it switches to the next player.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showWinnerAlert(_ winner: Int) {
        let message = (winner == 0) ? "Player 1 wins!" : "Player 2 wins!"
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        
        let replayAction = UIAlertAction(title: "Replay", style: .default) { _ in
            self.resetGame()
        }
        alert.addAction(replayAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    

    // MARK: - Animator
    
    
    private func setDieImageView(_ dieImageView: UIImageView, with sfSymbolName: String) {
        let symbolImage = UIImage(systemName: sfSymbolName)
        
        // 開始第一段動畫（縮放、設定 SF Symbol、設定顏色）
        UIViewPropertyAnimator(duration: 0.06, curve: .easeOut) {
            dieImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            dieImageView.image = symbolImage
            dieImageView.layer.cornerRadius = 15
            // dieImageView.clipsToBounds = true
        }.startAnimation()
        
        // 開始第二段動畫（取消縮放、添加符號效果）
        UIViewPropertyAnimator(duration: 0.06, curve: .linear, animations: {
            dieImageView.transform = .identity
            if #available(iOS 17.0, *) {
                // dieImageView.addSymbolEffect(.bounce)
            }
        }).startAnimation(afterDelay: 0.10) //前一個動畫跑完再動
    }
    
    
    
}

