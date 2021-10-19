//
//  ViewController.swift
//  sort characters
//
//  Created by Narek Arsenyan on 18.08.21.
//
protocol MagicSorting {
    func findDoubleZero(array: [Int], startIndex: Int) -> Int
    func swapTwoByTwo(array: [Int], index1: Int, index2: Int) -> [Int]
    func findNextMagicZeroIndex(array: [Int], startIndex: Int, alone: Bool) -> Int
    func findFirstZeroOneIndex(array: [Int]) -> Int
    func isSorted(array: [Int]) -> Bool
    func findZeroSequanceIndex(array: [Int]) -> Int
    func checkLastPairs() -> Void
    func lastZeroIndex() -> Int
    func magicSwap(firstZeroOneIndex: Int) -> Void
    func attemptOne(array: [Int], startIndex: Int) -> Void
    func attemptTwo(array: [Int], startIndex: Int) -> Void
    
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textViewReference: UITextView!
    @IBOutlet weak var textReference: UITextField!
    var array: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textReference.delegate = self
        buttonAction()
    }

    @IBAction func buttonAction() {
        textViewReference.text = ""
        if let text = textReference.text {
            let numbers = Array(text).map { Int(String($0))! }
            self.array = numbers
            let startIndex = findZeroSequanceIndex(array: self.array);
            attemptOne(array: self.array, startIndex: startIndex == -1 ? 0 : startIndex)
        }
    }
    
}

extension ViewController: MagicSorting {
    func magicSwap(firstZeroOneIndex: Int) {
        if firstZeroOneIndex > 1 {
            self.array = swapTwoByTwo(array: self.array, index1: 0, index2: firstZeroOneIndex)
        } else {
            self.array = swapTwoByTwo(array: self.array, index1: firstZeroOneIndex + 2, index2: firstZeroOneIndex)
        }
        attemptOne(array: self.array)
    }
    
    func lastZeroIndex() -> Int {
        for i in 0...self.array.endIndex - 1 {
            if self.array[self.array.endIndex - i - 1] == 0 {
                return self.array.endIndex - 1 - i
            }
        }
        return -1
    }
    
    func checkLastPairs() {
        let firstPairFromEnd = (self.array[self.array.endIndex - 2], self.array[self.array.endIndex - 1])
        let secondPairFromEnd = (self.array[self.array.endIndex - 4], self.array[self.array.endIndex - 3])
        if firstPairFromEnd == secondPairFromEnd {
            self.array = swapTwoByTwo(array: self.array, index1: self.array.endIndex - 2, index2: self.array.endIndex - 5)
        } else {
            self.array = swapTwoByTwo(array: self.array, index1: self.array.endIndex - 2, index2: self.array.endIndex - 4)
        }
        attemptOne(array: self.array, startIndex: self.array.endIndex - 4)
    }
    
    
    func attemptTwo(array: [Int], startIndex: Int = 0) {
        let doubleZeroIndex = findDoubleZero(array: self.array, startIndex: startIndex)
        if doubleZeroIndex != -1 {
            let sequnenceIndex = findZeroSequanceIndex(array: self.array)
            if sequnenceIndex == -1 {
                if doubleZeroIndex != 1 {
                    self.array = swapTwoByTwo(array: self.array, index1: doubleZeroIndex, index2: sequnenceIndex)
                    attemptOne(array: self.array, startIndex: 2)
                } else {
                    attemptTwo(array: self.array, startIndex: doubleZeroIndex + 1)
                }
            } else {
                if doubleZeroIndex - sequnenceIndex > 1 {
                    self.array = swapTwoByTwo(array: self.array, index1: doubleZeroIndex, index2: sequnenceIndex)
                } else {
                    self.array = swapTwoByTwo(array: self.array, index1: doubleZeroIndex, index2: sequnenceIndex - 1)
                }
                attemptOne(array: self.array, startIndex: sequnenceIndex + 1)
            }
        } else {
            let firstZeroOneIndex = findFirstZeroOneIndex(array: self.array)
            let lastZeroIndex = lastZeroIndex()
            if firstZeroOneIndex == lastZeroIndex {
                magicSwap(firstZeroOneIndex: firstZeroOneIndex)
            } else {
                let magicZeroIndex = findNextMagicZeroIndex(array: self.array, startIndex: firstZeroOneIndex + 1)
                if magicZeroIndex == -1 {
                    if isSorted(array: self.array) {
                        return
                    } else {
                        checkLastPairs()
                    }
                } else {
                    self.array = swapTwoByTwo(array: self.array, index1: firstZeroOneIndex, index2: magicZeroIndex)
                    attemptOne(array: self.array, startIndex: firstZeroOneIndex)
                }
            }
        }
    }
    
    
    func attemptOne(array: [Int], startIndex: Int = 0) {
        print(array)
        textViewReference.text += "\n\(array)\n"
        if isSorted(array: self.array) {
            return
        } else {
            attemptTwo(array: self.array, startIndex: startIndex)
        }
    }
    
    
    func findDoubleZero(array: [Int], startIndex: Int = 0) -> Int {
        for i in startIndex...self.array.endIndex - 2 {
            if self.array[i] == 0 && self.array[i + 1] == 0 {
                return i
            }
        }
        return -1
    }
    
    func swapTwoByTwo(array: [Int], index1: Int, index2: Int) -> [Int] {
        var arrayCopy = array
        arrayCopy.swapAt(index1, index2)
        arrayCopy.swapAt(index1 + 1, index2 + 1)
        return arrayCopy
    }
    
    func findFirstZeroOneIndex(array: [Int]) -> Int {
        for i in 0...self.array.endIndex - 2 {
            if self.array[i] == 0 && self.array[i + 1] == 1 {
                return i
            }
        }
        return -1
    }
    
    func findNextMagicZeroIndex(array: [Int], startIndex: Int, alone: Bool = false) -> Int {
        if startIndex >= self.array.endIndex - 2 {
            return -1
        }
        if alone {
            for i in startIndex...self.array.endIndex - 2 {
                if self.array[i] == 0 {
                    return i
                }
            }
        } else {
            for i in startIndex...self.array.endIndex - 3 {
                if self.array[i] == 0 && self.array[i + 1] == 1 {
                    return i + 1
                }
            }
        }
        return -1
    }
    
    func isSorted(array: [Int]) -> Bool {
        var box = 0
        for i in self.array {
            if i == 0 {
                box += 1
            }
        }
        for j in 0..<box {
            if self.array[j] == 1 {
                return false
            }
        }
        return true
    }
    
    func findZeroSequanceIndex(array: [Int]) -> Int {
        for i in 0...self.array.endIndex - 1 {
            if self.array[i] == 1 {
                return i
            }
        }
        return self.array.endIndex - 1
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "01")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

