import Foundation

var str = "Hello, playground"

let puzzleInput = [Int](206938...679128)

// MARK: Part 1

extension Int {
    var couldBePasswordPart1: Bool {
        let string = String(self)
        guard string.count == 6 else { return false }
        
        var adjacent = false
        var maxSoFar = 0
        var previous = 0
        
        for character in string {
            let int = Int(String(character))!
            guard int >= maxSoFar else { return false }
            maxSoFar = int
            
            if adjacent == false {
                if previous == int {
                    adjacent = true
                }
                previous = int
            }
        }
        
        return adjacent
    }
    
    var couldBePasswordPart1A: Bool {
        let string = String(self)
        guard string.count == 6 else { return false }
        
        var maxSoFar = 0
        
        let set = NSCountedSet()
        
        string.forEach { set.add($0) }
        
        for character in string {
            let int = Int(String(character))!
            guard int >= maxSoFar else { return false }
            maxSoFar = int
            
            guard set.count(for: character) >= 2 else { return false }
        }
        
        return true
    }
}

111111.couldBePasswordPart1 // Should be true
223450.couldBePasswordPart1 // Should be false
123789.couldBePasswordPart1 // Should be false

111111.couldBePasswordPart1A // Should be true
223450.couldBePasswordPart1A // Should be false
123789.couldBePasswordPart1A // Should be false

//let possiblePasswords = puzzleInput.filter { $0.couldBePasswordPart1 }
//
//print(possiblePasswords.count) // 1653 (correct)

// MARK: Part 2

extension Int {
    var couldBePasswordPart2: Bool {
        let string = String(self)
        guard string.count == 6 else { return false }
        
        var maxSoFar = 0
        
        let set = NSCountedSet()
        
        string.forEach { set.add($0) }
        
        var adjacent = false
        
        for character in string {
            let int = Int(String(character))!
            guard int >= maxSoFar else { return false }
            maxSoFar = int
            
            if adjacent == false {
                if set.count(for: character) == 2 {
                    adjacent = true
                }
            }
        }
        
        return adjacent
    }
}

112233.couldBePasswordPart2 // Should be true
123444.couldBePasswordPart2 // Should be false
111122.couldBePasswordPart2 // Should be true
122345.couldBePasswordPart2 // Should be true

let possiblePasswordsPart2 = puzzleInput.filter { $0.couldBePasswordPart2 }

print(possiblePasswordsPart2.count) // 1133 (correct)
