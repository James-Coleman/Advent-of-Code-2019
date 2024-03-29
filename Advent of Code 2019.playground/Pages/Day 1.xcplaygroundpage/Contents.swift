import UIKit

var str = "Hello, playground"

func fuelRequired(forMass mass: Int) -> Int {
    let dividedByThree = Double(mass) / 3
    let roundedDown = Int(dividedByThree.rounded(.down))
    let subtractedTwo = roundedDown - 2
    return subtractedTwo
}

// MARK: Examples

fuelRequired(forMass: 12) // 2 (correct)
fuelRequired(forMass: 14) // 2 (correct)
fuelRequired(forMass: 1969) // 654 (correct)
fuelRequired(forMass: 100756) // 33583 (correct)

let puzzleInput = """
129561
125433
97919
93037
73254
96511
115676
95032
69369
145385
111145
64368
83462
95765
133284
136563
67439
69311
147720
92632
142940
100610
106538
80025
121672
125386
126601
67943
120022
95914
132721
105831
138493
57649
72843
81754
103116
148993
139042
145929
61039
126034
74187
60750
99048
131776
123137
113098
107571
117050
108649
117455
147443
121863
104952
103465
128718
61795
121049
112010
74403
56153
136161
76872
94156
131477
91769
90744
118647
135791
98914
104988
62070
82308
71964
91477
63733
84412
127000
65449
67976
51400
56045
82951
101119
143015
99388
51796
93467
63220
124459
136330
130535
144270
88616
63626
139954
92191
117618
110422
"""

let mappedPuzzleInput = puzzleInput
    .components(separatedBy: "\n")
    .compactMap { Int($0) }

// MARK: Part 1

let part1Answer = mappedPuzzleInput
    .map { fuelRequired(forMass: $0) }
    .reduce(0, +)

print(part1Answer) // 3404722 (correct!)

// MARK: Part 2

func recursiveFuelRequired(forMass mass: Int, fuelSoFar: Int = 0) -> Int {
    let dividedByThree = Double(mass) / 3
    let roundedDown = Int(dividedByThree.rounded(.down))
    let subtractedTwo = roundedDown - 2
    
    if subtractedTwo <= 0 {
        return fuelSoFar
    } else {
        return subtractedTwo + recursiveFuelRequired(forMass: subtractedTwo)
    }
}

// MARK: Part 2 examples

recursiveFuelRequired(forMass: 14) // 2 (correct)
recursiveFuelRequired(forMass: 1969) // 966 (correct)
recursiveFuelRequired(forMass: 100756) // 50346 (correct)

// MARK: Part 2

let part2Answer = mappedPuzzleInput
    .map { recursiveFuelRequired(forMass: $0) }
    .reduce(0, +)

print(part2Answer) // 5104215 (correct!)
