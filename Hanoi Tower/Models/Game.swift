//
//  Game.swift
//  Hanoi Tower
//
//  Created by Danni on 12/24/18.
//  Copyright © 2018 Danni Chen. All rights reserved.
//

import Foundation

struct Game {
    
    var tower1:Tower
    var tower2:Tower
    var tower3:Tower
    
    init(with DiskNumber:Int) {
        tower1 = Tower(towerIdentifier:1,with:DiskNumber)
        let tower2 = Tower(identifier:2)
        let tower3 = Tower(identifier:3)
        self.tower2 = tower2
        self.tower3 = tower3
        
    }

//  function to determine what the transitional tower
    func getTheOtherTower(withTower1:Tower,withTower2:Tower)->Tower{
        switch withTower1.identifier {
        case 1:
            switch withTower2.identifier{
            case 2:
                return tower3
            default:
                return tower2
            }
        case 2:
            switch withTower2.identifier{
            case 1:
                return tower3
            default:
                return tower1
            }
        default:
            switch withTower2.identifier{
            case 1:
                return tower2
            default:
                return tower1
            }
        }
      
    }
    
    mutating func moveDisk(from startingTower:Tower,to endingTower:Tower){
        if moveOk(from: startingTower, to: endingTower){
            let disksOfStarting = startingTower.disks
            let topDiskFromStartingTower = disksOfStarting[0]
            startingTower.removeTop()
            endingTower.addDisk(with: topDiskFromStartingTower)
        }
            
        else{
            print("Illegal to move")
        }
    }
    
    private func moveOk(from tower1:Tower,to tower2:Tower) -> Bool{
        if let topDisk = tower1.getTopDisk(){
            return tower2.addOk(with: topDisk)
        }
        return false
    }
    
}
