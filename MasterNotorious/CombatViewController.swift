//
//  CombatViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 06.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class CombatViewController: UIViewController {

    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var monsterLabel: UILabel!
    @IBOutlet weak var healthValueLabel: UILabel!
    @IBOutlet weak var manaLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var attack1Button: UIButton!
    @IBOutlet weak var attack5Button: UIButton!
    @IBOutlet weak var skill1Button: UIButton!
    @IBOutlet weak var skill2Button: UIButton!
    @IBOutlet weak var attack10Button: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var skillStackView: UIStackView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var combatResultScrollView: UIScrollView!
    @IBOutlet weak var combatResultLabel: UILabel!
    var playerContainerVC:PlayerContainerViewController?
    var skillStackViewWidth:CGFloat!
    var skillStackViewHeight:CGFloat!
    var delegate:MasterNotoriousDelegate?
    
    var mode:eMode = .easy
    var playerFirst = true
    var monster = MonsterGenerator.Generate(level: 1, mode: .easy)
    var playerDead = false
    var monsterDead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dice = Dice.rollDice(.twenty)
        if dice < (6 + Double(mode.rawValue)) {
            playerFirst = false
        }
        
        combatResultScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: combatResultLabel.bottomAnchor).isActive = true
        combatResultScrollView.layer.borderWidth = 1
        combatResultScrollView.layer.borderColor = UIColor.gray.cgColor
        combatResultScrollView.layer.cornerRadius = 5.0
        
        setBorder(uiView: attackButton)
        setBorder(uiView: attack1Button)
        setBorder(uiView: attack5Button)
        setBorder(uiView: attack10Button)
        setBorder(uiView: skill1Button)
        setBorder(uiView: skill2Button)
        
        skillStackView.hide()
        skillStackViewWidth = skillStackView.frame.width + 50
        skillStackViewHeight = skillStackView.frame.height
        skillStackView.frame = CGRect(x: attackButton.frame.origin.x, y: attackButton.frame.origin.y, width: 0, height: 0)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMonsterStatus()
        setPlayerStatus()
        
        if player?.mana == 0 {
            skill1Button.isEnabled = false
            skill2Button.isEnabled = false
        }
        
        switch mode {
        case .easy:
            imgTop.image = UIImage(named:"hunt")
        case .moderate:
            imgTop.image = UIImage(named:"ambush")
        case .hard, .master:
            imgTop.image = UIImage(named:"bandit_camp")
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.combatResultScrollView.scrollToBottom(animated: true)
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playerContainerVC = segue.destination as? PlayerContainerViewController {
            self.playerContainerVC = playerContainerVC
        }
    }
    
    @IBAction func attackTapped(_ sender: Any) {
        attackButton.hide()
        UIView.animate(withDuration: 0.3, animations: showAnimatedButtons)
    }
    
    @IBAction func attack1Tapped(_ sender: Any) {
        attack(nil, .x1)
        UIView.animate(withDuration: 0.3, animations: hideAnimatedButtons)
    }
    
    @IBAction func attack5Tapped(_ sender: Any) {
        attack(nil, .x5)
        UIView.animate(withDuration: 0.3, animations: hideAnimatedButtons)
    }
    
    @IBAction func attack10Tapped(_ sender: Any) {
        attack(nil, .x10)
        UIView.animate(withDuration: 0.3, animations: hideAnimatedButtons)
    }
    
    @IBAction func runTapped(_ sender: Any) {
        if !self.monsterDead && !self.playerDead {
            addCombatResultText("Coward!", redColor: true)
            let escape = Dice.rollDice(.twenty)
            if escape <= Double(mode.rawValue) {
                attack(nil, .x1)
                addCombatResultText("You cannot escape!", redColor: false)
                return
            }
        }
        
        if mode == .master {
            if self.monsterDead {
                if (player?.level.current)! < 15 {
                    player?.level.levelUp()
                    player?.calculateLevel()
                    self.delegate?.setLevelUp()
                } else {
                    playerRepository.updatePlayer(player:player!)
                    performSegue(withIdentifier: "restartSegue", sender: self)
                    return
                }
            } else {
                player?.decreaseStamina()
                player?.decreaseStamina()
            }
            player?.fullHeal()
            player?.fullRecover()
        } else {
            player?.decreaseStamina()
        }
        
        playerRepository.updatePlayer(player: player!)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skill1Tapped(_ sender: Any) {
        let skillUsed = player?.skill[0]
        attack(skillUsed, .x1)
        
        if (player?.mana)! < (skillUsed?.mana)! {
            skill1Button.isEnabled = false
        }
        if player?.mana == 0 {
            skill2Button.isEnabled = false
        }
        
        UIView.animate(withDuration: 0.3, animations: hideAnimatedButtons)
    }
    
    @IBAction func skill2Tapped(_ sender: Any) {
        let skillUsed = player?.skill[1]
        attack(skillUsed, .x1)
        
        if (player?.mana)! < (skillUsed?.mana)! {
            skill2Button.isEnabled = false
        }
        if player?.mana == 0 {
            skill1Button.isEnabled = false
        }
        
        UIView.animate(withDuration: 0.3, animations: hideAnimatedButtons)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func showAnimatedButtons() {
        self.skillStackView.show()
        skillStackView.frame = CGRect(x: attackButton.frame.origin.x, y: attackButton.frame.origin.y, width: skillStackViewWidth, height: skillStackViewHeight)
        attackButton.hide()
    }
    
    fileprivate func hideAnimatedButtons() {
        self.skillStackView.hide()
        skillStackView.frame = CGRect(x: attackButton.frame.origin.x, y: attackButton.frame.origin.y, width: 0, height: 0)
        attackButton.show()
    }
    
    func disableButtons() {
        attackButton.isEnabled = false
        attackButton.backgroundColor = UIColor.lightGray
        setBorder(uiView: attackButton, color: UIColor.lightGray.cgColor)
    }
    
    fileprivate func attack(_ skillUsed: Skill?,_ turns:Turns) {
        for _ in 1...turns.rawValue {
            if playerFirst {
                var resultText = Combat.fight(player!, monster, playerAttack: true, skill: skillUsed)
                healthValueLabel.text = String(monster.health)
                playerContainerVC?.updateStatus()
                addCombatResultText(resultText, redColor:false)
                if monster.health <= 0 {
                    setEndGame(monsterDead: true)
                    break
                }
                resultText = Combat.fight(player!, monster, playerAttack: false, skill: nil)
                playerContainerVC?.updateStatus()
                addCombatResultText(resultText, redColor:false)
                if (player?.health)! <= 0 {
                    setEndGame(monsterDead: false)
                    break
                }
            } else {
                var resultText = Combat.fight(player!, monster, playerAttack: false, skill: nil)
                playerContainerVC?.updateStatus()
                addCombatResultText(resultText, redColor:false)
                if (player?.health)! <= 0 {
                    setEndGame(monsterDead: false)
                    break
                }
                resultText = Combat.fight(player!, monster, playerAttack: true, skill: skillUsed)
                healthValueLabel.text = String(monster.health)
                playerContainerVC?.updateStatus()
                addCombatResultText(resultText, redColor:false)
                if monster.health <= 0 {
                    setEndGame(monsterDead: true)
                    break
                }
            }
        }
    }
    
    fileprivate func setEndGame(monsterDead: Bool) {
        self.monsterDead = monsterDead
        self.playerDead = !monsterDead
        if self.playerDead {
            player?.fullRecover()
            player?.fullHeal()
            player?.stamina = (player?.maxStamina)!
            player?.gold = Int((player?.gold)! / 2)
            player?.level.exp = Int(Double((player?.level.exp)!) * 0.9)
            playerRepository.updatePlayer(player: player!)
            
            performSegue(withIdentifier: "underSegue", sender: self)
        } else {
            if mode == .master {
                addCombatResultText("You defeated your master.", redColor: true)
            } else {
                let gold = Combat.calculateGold(level: (player?.level.current)!)
                let exp = Combat.calculateExp(mode: mode, level: (player?.level.current)!, monsterBaseExp: monster.baseExp)
                player?.receive(gold)
                player?.level.exp += exp
                addCombatResultText("You gained \(gold) gold piece(s) and \(exp) experience.", redColor: false)
                addCombatResultText("\(player?.name ?? "You") killed \(monster.name)", redColor: true)
            }
        }
        
        runButton.setTitle("Exit", for: .normal)
        disableButtons()
        playerContainerVC?.updateStatus()
        playerRepository.updatePlayer(player: player!)
    }
    
    fileprivate func addCombatResultText(_ text:String) {
        combatResultLabel.text = (combatResultLabel?.text)! + "\n- \(text)"
        combatResultScrollView.scrollToBottom(animated: true)
    }
    
    fileprivate func addCombatResultText(_ text:String, redColor:Bool) {
        let combatResultTextLength = combatResultLabel.text?.count
        let attributedText = NSAttributedString(string: combatResultLabel.text! + "\n- \(text)")
        let nsText = NSMutableAttributedString(attributedString: attributedText)
        nsText.addAttribute(.foregroundColor, value: redColor ? UIColor.red : UIColor.black, range: NSRange(location: combatResultTextLength!, length: text.count + 3))
        
        combatResultLabel.attributedText = nsText
        combatResultScrollView.scrollToBottom(animated: true)
    }
    
    fileprivate func setMonsterStatus() {
        monster = MonsterGenerator.Generate(level: (player?.level.current)!, mode: mode)
        monsterLabel.text = monster.name
        healthValueLabel.text = String(monster.health)
        manaLabel.text = String(monster.mana)
        attackLabel.text = String(monster.attack)
        defenseLabel.text = String(monster.defense)
    }
    
    fileprivate func setPlayerStatus() {
        playerContainerVC?.updateStatus()
        skill1Button.setTitle("\(player?.skill[0].name ?? "Skill1")", for: .normal)
        skill2Button.setTitle("\(player?.skill[1].name ?? "Skill2")", for: .normal)
        
        skill1Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        skill2Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    fileprivate func setBorder(uiView:UIView) {
        setBorder(uiView: uiView, color: UIColor.blue.cgColor)
    }
    
    fileprivate func setBorder(uiView:UIView, color: CGColor) {
        uiView.layer.borderWidth = 1
        uiView.layer.borderColor = color
        uiView.layer.cornerRadius = 8.0
    }
}
