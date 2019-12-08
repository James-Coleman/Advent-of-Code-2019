import Foundation
import CoreGraphics

var str = "Hello, playground"

enum Day3Error: Error {
    case noDirectionInput
    case cannotConvertToInt
    case unknownDirection(Character)
    case noCrossingPoints
}

enum Direction {
    case up(CGFloat)
    case down(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
    
    init(input: String) throws {
        guard let firstCharacter = input.first else { throw Day3Error.noDirectionInput }
        
        guard let int = Int(input.dropFirst()) else { throw Day3Error.cannotConvertToInt }
        
        switch firstCharacter {
        case "U":
            self = .up(CGFloat(int))
        case "D":
            self = .down(CGFloat(int))
        case "L":
            self = .left(CGFloat(int))
        case "R":
            self = .right(CGFloat(int))
        default:
            throw Day3Error.unknownDirection(firstCharacter)
        }
    }
}

/*
try? Direction(input: "R8")
try? Direction(input: "U5")
try? Direction(input: "L5")
try? Direction(input: "D3")
*/

func position(after direction: Direction, startingAt start: CGPoint = CGPoint(x: 0, y: 0)) -> CGPoint {
    switch direction {
    case .up(let distance):
        return CGPoint(x: start.x, y: start.y + distance)
    case .down(let distance):
        return CGPoint(x: start.x, y: start.y - distance)
    case .left(let distance):
        return CGPoint(x: start.x - distance, y: start.y)
    case .right(let distance):
        return CGPoint(x: start.x + distance, y: start.y)
    }
}

//position(after: .up(5))

extension CGPoint {
    func position(after direction: Direction) -> CGPoint {
        switch direction {
        case .up(let distance):
            return CGPoint(x: self.x, y: self.y + distance)
        case .down(let distance):
            return CGPoint(x: self.x, y: self.y - distance)
        case .left(let distance):
            return CGPoint(x: self.x - distance, y: self.y)
        case .right(let distance):
            return CGPoint(x: self.x + distance, y: self.y)
        }
    }
}

/*
CGPoint(x: 0, y: 0)
    .position(after: .up(5))
    .position(after: .down(3))
    .position(after: .left(10))
*/

func directionsArray(from input: String) throws -> [Direction] {
    let inputComponents = input.components(separatedBy: ",")
    
    let nonEmpty = inputComponents.filter { $0.isEmpty == false }
    
    return try nonEmpty.map { try Direction(input: $0) }
}

/*
do {
    let exampleString1 = "R8,U5,L5,D3"
    let directions1 = try directionsArray(from: exampleString1)
    
    let exampleString2 = "U7,R6,D4,L4,"
    let directions2 = try directionsArray(from: exampleString2)
} catch {
    print(error)
}
*/

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.finalize()
    }
}

struct PointDisplacement: Hashable {
    let point: CGPoint
    let displacement: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
    }
    
    static var zero: PointDisplacement {
        return PointDisplacement(point: CGPoint.zero, displacement: 0)
    }
    
    /*
    func pointsCoveredByMoving(_ direction: Direction) -> Set<PointDisplacement> {
        var setToReturn: Set<PointDisplacement> = []
        
        let destination = self.point.position(after: direction)
        
        var newPoint = self
        
        while newPoint != destination {
            switch direction {
            case .up:
                newPoint = CGPoint(x: newPoint.x, y: newPoint.y + 1)
                setToReturn.insert(newPoint)
            case .down:
                newPoint = CGPoint(x: newPoint.x, y: newPoint.y - 1)
                setToReturn.insert(newPoint)
            case .left:
                newPoint = CGPoint(x: newPoint.x - 1, y: newPoint.y)
                setToReturn.insert(newPoint)
            case .right:
                newPoint = CGPoint(x: newPoint.x + 1, y: newPoint.y)
                setToReturn.insert(newPoint)
            }
        }
        
        return setToReturn
    }
    */
}

//var set = Set<PointDisplacement>()

extension CGPoint {
    func pointsCoveredByMoving(_ direction: Direction) -> Set<CGPoint> {
        var setToReturn: Set<CGPoint> = []
        
        let destination = self.position(after: direction)
        
        var newPoint = self
        
        while newPoint != destination {
            switch direction {
            case .up:
                newPoint = CGPoint(x: newPoint.x, y: newPoint.y + 1)
                setToReturn.insert(newPoint)
            case .down:
                newPoint = CGPoint(x: newPoint.x, y: newPoint.y - 1)
                setToReturn.insert(newPoint)
            case .left:
                newPoint = CGPoint(x: newPoint.x - 1, y: newPoint.y)
                setToReturn.insert(newPoint)
            case .right:
                newPoint = CGPoint(x: newPoint.x + 1, y: newPoint.y)
                setToReturn.insert(newPoint)
            }
        }
        
        return setToReturn
    }
    
    func routeOfPointsByMoving(_ direction: Direction) -> [CGPoint] {

        let intX = Int(self.x)
        let intY = Int(self.y)
        
        switch direction {
        case .up(let displacement):
            let intDisplacement = Int(displacement)
            let newYs = intY + 1...intY + intDisplacement
            return newYs.map { CGPoint(x: intX, y: $0) }
        case .down(let displacement):
            let intDisplacement = Int(displacement)
            let newYs = intY - intDisplacement...intY - 1
            return newYs.map { CGPoint(x: intX, y: $0) }.reversed()
        case .left(let displacement):
            let intDisplacement = Int(displacement)
            let newXs = intX - intDisplacement...intX - 1
            return newXs.map { CGPoint(x: $0, y: intY) }.reversed()
        case .right(let displacement):
            let intDisplacement = Int(displacement)
            let newXs = intX + 1...intX + intDisplacement
            return newXs.map { CGPoint(x: $0, y: intY) }
        }
    }
}

//CGPoint(x: 0, y: 0).pointsCoveredByMoving(.right(8))

extension CGPoint {
    func pointsCoveredByMoving(_ directions: [Direction]) -> Set<CGPoint> {
        var setToReturn = Set<CGPoint>()
        
        var newPoint = self
        
        for direction in directions {
            let pointsCovered = newPoint.pointsCoveredByMoving(direction)
            setToReturn = setToReturn.union(pointsCovered)
            newPoint = newPoint.position(after: direction)
        }
        
        return setToReturn
    }
    
    func routeOfPointsByMoving(_ directions: [Direction]) -> [CGPoint] {
        var arrayToReturn = [CGPoint]()
        
        var newPoint = self
        
        for direction in directions {
            let routeTo = newPoint.routeOfPointsByMoving(direction)
            arrayToReturn += routeTo
            newPoint = newPoint.position(after: direction)
        }
        
        return arrayToReturn
    }
}

//CGPoint(x: 0, y: 0).pointsCoveredByMoving([.up(2), .right(3)])

extension CGPoint {
    var manhattenDistanceToOrigin: Int {
        return Int(abs(x) + abs(y))
    }
}

func nearestOverlappingPoint(path1: String, path2: String) throws -> Int {
    let directions1 = try directionsArray(from: path1)
    let directions2 = try directionsArray(from: path2)
    
    let pointsCovered1 = CGPoint.zero.pointsCoveredByMoving(directions1)
    let pointsCovered2 = CGPoint.zero.pointsCoveredByMoving(directions2)
    
    let pointsCoveredByBoth = pointsCovered1.intersection(pointsCovered2)
    
    let sortedPoints = pointsCoveredByBoth.sorted { $0.manhattenDistanceToOrigin < $1.manhattenDistanceToOrigin }
    
    guard let nearestPoint = sortedPoints.first else { throw Day3Error.noCrossingPoints }
    
    nearestPoint
    
    return nearestPoint.manhattenDistanceToOrigin
}

func shortestRouteToFirstOverlappingPoint(path1: String, path2: String) throws -> Int {
    let directions1 = try directionsArray(from: path1)
    let directions2 = try directionsArray(from: path2)
    
    let pointsCovered1 = CGPoint.zero.routeOfPointsByMoving(directions1)
    let pointsCovered2 = CGPoint.zero.routeOfPointsByMoving(directions2)
    
    // Make a set here? Just for the purposes of finding crossover?
    
    let set1 = Set(pointsCovered1)
    let set2 = Set(pointsCovered2)
    
    let pointsInBoth = set1.intersection(set2)
    
    let firstVisits1 = pointsInBoth.compactMap { pointsCovered1.firstIndex(of: $0) }.map { Int($0) }
    let firstVisits2 = pointsInBoth.compactMap { pointsCovered2.firstIndex(of: $0) }.map { Int($0) }
    
    let totalDistances = firstVisits1.enumerated().map { index, distance1 -> Int in
        let distance2 = firstVisits2[index]
        let total = distance1 + distance2
        return total
    }
    
    let sortedDistances = totalDistances.sorted(by: <)
    
    let shortestDistance = sortedDistances.first
    
//    print(pointsInBoth)
    
    return (shortestDistance ?? 0) + 2 // Need to + 2. Once because we don't count the origin, once because the index in the array will be the number of steps -1.
}

do {
    
    // MARK: Part 1 examples
//    let part1Example1 = try nearestOverlappingPoint(path1: "R8,U5,L5,D3,", path2: "U7,R6,D4,L4,")
    
//    let part1Example2 = try nearestOverlappingPoint(path1: "R75,D30,R83,U83,L12,D49,R71,U7,L72", path2: "U62,R66,U55,R34,D71,R55,D58,R83")
    
//    let part1Example3 = try nearestOverlappingPoint(path1: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", path2: "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
    
    // MARK: Part 2 examples
//    let part2Example1 = try shortestRouteToFirstOverlappingPoint(path1: "R8,U5,L5,D3,", path2: "U7,R6,D4,L4,")
//    let part2Example2 = try shortestRouteToFirstOverlappingPoint(path1: "R75,D30,R83,U83,L12,D49,R71,U7,L72", path2: "U62,R66,U55,R34,D71,R55,D58,R83")
//    let part2Example3 = try shortestRouteToFirstOverlappingPoint(path1: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", path2: "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
    
} catch {
    print(error)
}

let puzzleInput = """
R1001,D890,R317,U322,L481,D597,L997,U390,L78,D287,L401,U638,R493,D493,R237,U29,R333,D466,L189,D634,R976,U934,R597,U62,L800,U229,R625,D927,L629,D334,L727,U4,R716,U20,L284,U655,R486,U883,R194,U49,L845,D960,R304,D811,L38,U114,R477,D318,L308,U445,L26,D44,R750,D12,R85,D146,R353,U715,R294,D595,L954,U267,L927,U383,L392,D866,L195,U487,L959,U630,R528,D482,R932,D541,L658,D171,L964,U687,R118,U53,L81,D381,R592,U238,L391,U399,R444,U921,R706,U925,R204,D220,L595,U489,R621,D15,R104,D567,L664,D54,R683,U654,R441,D748,L212,D147,L699,U296,L842,U230,L684,D470,R247,D421,R38,D757,L985,U791,R112,U494,R929,D726,L522,U381,R184,D492,L517,D819,R487,D620,R292,D206,R254,D175,L16,U924,R838,D423,R756,D720,L555,U449,L952,D610,L427,U391,R520,D957,R349,D670,L678,U467,R804,U757,L342,U808,R261,D597,L949,U162,R3,D712,L799,U531,R879,D355,R325,D173,L303,U679,L432,D421,R613,U431,L207,D669,R828,D685,R808,U494,R821,U195,L538,U16,L835,D442,L77,U309,L490,U918,L6,D200,L412,D272,L416,U774,L75,D23,L193,D574,R807,D382,L314,D885,R212,D806,L183,U345,L932,U58,L37,U471,R345,U678,R283,U644,L559,U892,L26,D358,L652,D606,L251,U791,L980,D718,L14,D367,R997,D812,R504,D474,L531,U708,R660,U253,L86,D491,R971,U608,L166,U659,R167,U92,L600,U20,R28,U852,R972,D409,L719,D634,R787,D796,L546,D857,L987,U111,L916,D108,R537,U931,R308,U385,L258,D171,R797,U641,R798,D723,R600,D710,R436,U587,R16,D564,L14,D651,R709,D587,R626,U270,R802,U937,R31,U518,L187,D738,R562,D238,R272,D403,R788,D859,L704,D621,L547,D737,L958,U311,L927
L1007,U199,L531,D379,L313,U768,L87,U879,R659,U307,L551,D964,L725,D393,R239,D454,R664,U402,R100,D62,R53,D503,R918,U998,L843,D142,R561,U461,R723,D915,L217,D126,L673,U171,R131,U518,R298,U99,L852,D799,L159,U161,R569,D802,L391,D553,L839,U954,R502,U351,R851,D11,L243,D774,L642,U613,R376,U867,L357,D887,L184,D298,R406,U912,R900,D348,L779,U494,R240,D712,R849,D684,R475,D449,L94,U630,L770,D426,L304,D869,R740,D377,R435,D719,L815,D211,R391,U484,R350,U599,R57,U210,R95,U500,L947,D649,R615,D404,L953,D468,R380,U215,R82,D872,R150,D347,L700,D450,L90,U803,L593,U296,R408,U667,R407,U725,R197,U269,R115,D758,R558,U62,L519,U308,R259,U869,L846,U3,R592,D357,R633,D909,L826,U165,L190,D821,L525,U404,R63,D214,R265,U74,L715,U461,L840,D647,R782,D655,R72,D601,L435,U549,L108,U687,R836,D975,L972,U813,R258,U703,R90,D438,R434,D818,R184,D886,R271,U31,L506,U395,L274,U455,R699,U889,L162,U771,R752,U317,R267,D959,R473,U58,R552,U51,R637,D726,R713,D530,L209,D824,R275,D207,R357,D373,L169,U880,L636,U409,R67,D740,R225,D272,R114,U970,R51,U230,R859,U820,L979,D153,R16,D883,L542,U806,L523,D752,L712,U55,L739,U746,R910,D873,R108,D558,L54,D619,L444,U941,R613,U478,L839,D910,R426,D614,L622,U928,L65,D644,L208,U971,L939,U874,R827,U672,L620,U140,L493,D637,L767,U831,R874,U468,R648,U714,R294,D606,L375,D962,L105,D919,L486,D771,L827,D196,L408,U217,L960,D633,L850,U805,L188,U566,L884,D212,L677,D204,R257,D409,R309,D783,L773,D588,L302,U129,L550,U919,L482,U563,R290,U690,R586,D460,L771,D63,R451,D591,L861,D598,L432,U818,L182
"""

let inputComponents = puzzleInput.components(separatedBy: "\n")

// MARK: Part 1

/*
do {
    let part1 = try nearestOverlappingPoint(path1: inputComponents[0], path2: inputComponents[1]) // 352 (correct!)
} catch {
    print(error)
}
*/

// MARK: Part 2

do {
    let part2 = try shortestRouteToFirstOverlappingPoint(path1: inputComponents[0], path2: inputComponents[1])
    print(part2) // 43848 (correct!)
} catch {
    print(error)
}
