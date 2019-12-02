import Foundation

var str = "Hello, playground"

enum Day2Error: Error {
    case notAnInt(string: String)
    case unknownInt(int: Int)
}

func numberLineAsArray(input: String) throws -> [Int] {
    var arrayToReturn: [Int] = []
    
    let split = input.components(separatedBy: ",")
    
    try split.enumerated().forEach { (offset, element) in
        guard let int = Int(element) else { throw Day2Error.notAnInt(string: element) }
        arrayToReturn += [int]
    }
    
    return arrayToReturn
}

func processedArray(starting array: [Int]) throws -> [Int] {
    var arrayToReturn = array
    
    var indexToCheck = 0
    
    while true {
        defer {
            indexToCheck += 1
        }
        
        if indexToCheck > (arrayToReturn.count) {
            indexToCheck = 0
        }
        
        let mod = indexToCheck % 4
//        print(indexToCheck)
        guard mod == 0 else { continue }
        
        let int = arrayToReturn[indexToCheck]
        
        if int == 99 {
            indexToCheck
            int
            return arrayToReturn
        }
        
        let firstNumber = arrayToReturn[arrayToReturn[indexToCheck + 1]]
        let secondNumber = arrayToReturn[arrayToReturn[indexToCheck + 2]]
        
        if int == 1 {
            let result = firstNumber + secondNumber
            arrayToReturn[arrayToReturn[indexToCheck + 3]] = result
        } else if int == 2 {
            let result = firstNumber * secondNumber
            arrayToReturn[arrayToReturn[indexToCheck + 3]] = result
        }
        
    }
    
    return arrayToReturn
}

let example = "1,9,10,3,2,3,11,0,99,30,40,50"

do {
    let array = try numberLineAsArray(input: example)
//    print(array)
    
//    let exampleProcessedArray = try processedArray(starting: array)
//    print(exampleProcessedArray) // [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50] (correct!)
} catch {
    print(error)
}

let example1 = "1,0,0,0,99"
let example2 = "2,3,0,3,99"
let example3 = "2,4,4,5,99,0"
let example4 = "1,1,1,4,99,5,6,0,99"

do {
//    let array1 = try numberLineAsArray(input: example1)
//    let array2 = try numberLineAsArray(input: example2)
//    let array3 = try numberLineAsArray(input: example3)
//    let array4 = try numberLineAsArray(input: example4)
    
//    let processed1 = try processedArray(starting: array1)
//    let processed2 = try processedArray(starting: array2)
//    let processed3 = try processedArray(starting: array3)
//    let processed4 = try processedArray(starting: array4)
    
//    print(processed1)
//    print(processed2)
//    print(processed3)
//    print(processed4) // [30, 1, 1, 4, 2, 5, 6, 0, 99] (should be [30,1,1,4,2,5,6,0,99]
} catch {
    print(error)
}

let puzzleInput = """
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,6,19,1,9,19,23,2,23,10,27,1,27,5,31,1,31,6,35,1,6,35,39,2,39,13,43,1,9,43,47,2,9,47,51,1,51,6,55,2,55,10,59,1,59,5,63,2,10,63,67,2,9,67,71,1,71,5,75,2,10,75,79,1,79,6,83,2,10,83,87,1,5,87,91,2,9,91,95,1,95,5,99,1,99,2,103,1,103,13,0,99,2,14,0,0
"""

do {
    var puzzleInputAsArray = try numberLineAsArray(input: puzzleInput)
    
    // Manual instructions
    
    puzzleInputAsArray[1] = 12
    puzzleInputAsArray[2] = 2
    
    let processedPart1 = try processedArray(starting: puzzleInputAsArray)
    
    print(processedPart1[0]) // 3931283 (correct!)
} catch {
    print(error)
}
