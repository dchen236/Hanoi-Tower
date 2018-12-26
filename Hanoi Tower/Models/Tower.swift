//
//  Tower.swift
//  Hanoi Tower
//
//  Created by Danni on 12/24/18.
//  Copyright © 2018 Danni Chen. All rights reserved.
//

import Foundation

class Tower {
    var disks:[Disk]
    var identifier:Int
    
    lazy var count = disks.count
    
    init(identifier:Int) {
        disks = [Disk]()
        self.identifier = identifier
    }
    convenience init(towerIdentifier:Int,with NumberOfDisks:Int) {
        
        self.init(identifier:towerIdentifier)
        for i in 1...NumberOfDisks{
            let disk = Disk(level:i )
            disks.append(disk)
        }
    }
    
    func getTopDisk() -> Disk?{
        if disks.count == 0 {
            return nil
        }
        else{
            return disks[0]
        }
    }
    
    func removeTop() {
        let count = disks.count
        if count == 0{
            print("No disks can be removed currently")
        }
        disks.remove(at: 0)
    }
    
    func addDisk(with addingDisk:Disk){
        if addOk(with: addingDisk){
            disks.insert(addingDisk, at: 0)
        }
        else{
            print("Larger disk can't be on top")
        }
    }
    

    func addOk(with addingDisk:Disk) -> Bool{
        let count = disks.count
            if count == 0{
                return true
            }
            else{
                let topDisk = disks[0]
                return topDisk.level > addingDisk.level
            }
        
    }
    
    
    
}
