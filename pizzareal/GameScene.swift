//  GameScene.swift
//  pizzaland_ios
//
//  Created by Kaan Şenol on 19.02.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var base_speed = 200;
    var player_advantage = 100;
    var player = SKSpriteNode();
    var pizza = SKSpriteNode();
    var background = SKSpriteNode();
    var score = 0;
    var hits = 0;
    var score_counter = SKLabelNode();
    var failed_text = SKLabelNode();
    var failed : Bool = false;
    var hits_counter = SKLabelNode();
    override func didMove(to view: SKView) {
        pizza = SKSpriteNode(imageNamed: "pizza")
        background = SKSpriteNode(imageNamed: "bg")
        background.size = CGSize(width: 500, height :500)
        
        pizza.size = CGSize(width: 48, height : 48)
        resetPizza();
        self.addChild(pizza);
        player = SKSpriteNode(imageNamed: "canvas")
        player.position = CGPoint(x: 10, y: -120);
        player.size = CGSize(width: 48, height : 48)
        
        score_counter = SKLabelNode(fontNamed: "Chalkduster")
        score_counter.text = "Score: 0"
        score_counter.fontSize = 24
        score_counter.fontColor = SKColor.green
        score_counter.position = CGPoint(x: frame.midX - 100, y: 200)
        self.addChild(score_counter)
        hits_counter = SKLabelNode(fontNamed: "Chalkduster")
        hits_counter.text = "Misses: 0"
        hits_counter.fontSize = 24
        hits_counter.fontColor = SKColor.red
        hits_counter.position = CGPoint(x: frame.midX + 100, y: 200)
        self.addChild(hits_counter)
        self.addChild(player)
        background.zPosition = -1;
        self.insertChild(background, at: 0)
        failed_text = SKLabelNode(fontNamed: "Chalkduster");
        failed_text.text = "Game Over";
        failed_text.fontSize = 32;
        failed_text.color = SKColor.red;
        failed_text.position = CGPoint(x: frame.midX, y: frame.midY);
        //
        
    }

    func resetPizza(){
        let xpos = Int.random(in: -190..<190)
        pizza.run(SKAction.move(to: CGPoint(x: xpos, y: 250), duration: 0))
        let distance : Float = abs(Float(player.position.y) - 250);
        pizza.run(SKAction.move(to: CGPoint(x: xpos, y: -255), duration: Double(distance/Float(base_speed))))
    }

func checkCollision() -> Bool{
    let rect_a = CGRect(x: player.position.x, y: player.position.y, width: player.size.width, height: player.size.height);
    let rect_b = CGRect(x: pizza.position.x, y: pizza.position.y, width: pizza.size.width, height: pizza.size.height);
    if(CGRectIntersectsRect(rect_a, rect_b)){
        return true;
    }
    else{
        return false;
    }
}
         
    func touchDown(atPoint pos : CGPoint){
        if(failed){
            failed = false;
            failed_text.removeFromParent()
            self.addChild(player)
            self.addChild(pizza)
            return;
        }
        let newpos = CGPoint(x: pos.x , y: player.position.y);
        let distance : Float = abs(Float(player.position.x) - Float(pos.x));
        player.run(SKAction.move(to: newpos, duration: Double(distance/Float(base_speed + player_advantage))))
    }
    
    

    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    

    
    
    
    override func update(_ currentTime: TimeInterval) {
        score_counter.text = "Score: " + String(score);
        hits_counter.text = "Misses: " + String(hits);
        if(failed){
            return;
        }
        // Called before each frame is rendered
        if(checkCollision()){
            resetPizza();
            score += 1;
        }
        
        if(pizza.position.y < -250){
            resetPizza();
            hits += 1;
            if(hits == 5){
                pizza.run(SKAction.move(to: CGPoint(x: 0, y: 255), duration: 0))
                player.removeFromParent()
                pizza.removeFromParent()
                failed = true;
                hits = 0;
                score = 0;
                self.addChild(failed_text);
                return;
            }
        }
        base_speed = 200 + score * 2;
    }
}
