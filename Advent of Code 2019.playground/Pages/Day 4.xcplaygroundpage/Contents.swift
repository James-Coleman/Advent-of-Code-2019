import Foundation

var str = "Hello, playground"

extension Int {
    var couldBePassword: Bool {
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
}

111111.couldBePassword // Should be true
223450.couldBePassword // Should be false
123789.couldBePassword // Should be false

let puzzleInput = [Int](206938...679128)

// MARK: Part 1

let possiblePasswords = puzzleInput.filter { $0.couldBePassword }

print(possiblePasswords.count) // 1653 (correct)
