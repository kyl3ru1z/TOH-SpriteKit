//
//  TowerModel.swift
//  TowerSprite
//
//  Created by Student User on 10/26/20.
//  Copyright © 2020 Student User. All rights reserved.
//

import Foundation

class TowerModel {
    private var data: [[Int]] = [[3, 2, 1], [], []]
    public func showData() -> [[Int]] {return data}
    private let winState: [[Int]] = [[], [], [3, 2, 1]]
    private var previous: Int = 0
    private var floater: Int?
    private var moves: Int = 0
    public func addMoves(){moves += 1}
    private var hasWon: Bool = false
    private var illegalMove: Bool = false
    public func getWinState() -> Bool {return hasWon}
    public func getIllegalMove() -> Bool {return illegalMove}
    public func getFloater() -> Int {
        guard let floater = floater else {return 0}
        return floater
    }
    public func getMoves() -> Int {moves}
    public func get(tower target : Int) -> [Int] {return data[target]}
    /* dyessick */
    public func peek(_ which: Int) -> Int { //what's on top? 0 if empty
        return data[which].last ?? 0 //return 0 when last is nil
    }
    public func pickUp(_ which: Int) {
        previous = which
        floater = data[which].popLast()
    }
    public func dropDown (_ which: Int) {
        guard let pickedDisc = floater else {return}
        if let topDisc = data[which].last {
            guard pickedDisc < topDisc else {
                illegalMove = true
                data[previous].append(pickedDisc)
                floater = nil
                return
            }
        }
        illegalMove = false
        floater = nil
        moves += 1
        data[which].append(pickedDisc)
    }
    public func checkWin() {
        guard data == winState else {return}
        hasWon = true
    }
}
