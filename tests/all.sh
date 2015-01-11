#!/usr/bin/env bash


fileUnderTest="${BASH_SOURCE%/*}/../jq/main.jq"

# TODO: more inspired tests.
read -d '' fourLineTests <<-'EOF' || true
repeat: Can YOLO from the right.
"YO"
repeat(3; . + "LO")
"YOLOLOLO"

repeat: Can YOLO from the left.
"LO"
repeat(3; "YO" + .)
"YOYOYOLO"

repeat: Can repeat no times.
0
repeat(0; . - 1)
0

repeat: Can repeat one time.
1
repeat(1; . - 1)
0

repeat: Can repeat ten times starting from 100.
100
repeat(10; . - 1)
90

repeat: Can recurse into objects 2 levels deep.
{ "a": { "a": { "a": "deep" } } }
repeat(2; .a)
{ "a": "deep" }

repeat: Can recurse into objects 3 levels deep.
{ "a": { "a": { "a": "deep" } } }
repeat(3; .a)
"deep"

repeat: Can build objects 1 levels from string.
{ "a": "deep" }
repeat(1; { a: . })
{ "a": { "a": "deep" } }

repeat: Can build objects 2 levels from string.
{ "a": "deep" }
repeat(2; { a: . })
{ "a": { "a": { "a": "deep" } } }

repeat: Can build objects 2 levels deep.
"deep"
repeat(2; { a: . })
{ "a": { "a": "deep" } }

repeat: Can build objects 3 levels deep.
"deep"
repeat(3; { a: . })
{ "a": { "a": { "a": "deep" } } }

repeat: Can recurse into arrays 2 levels deep.
[ 1, [ 2, [ 3, 4 ], 5 ], 6 ]
repeat(2; .[1])
[ 3, 4 ]

repeat: Can recurse into arrays 3 levels deep.
[ 1, [ 2, [ 3, 4 ], 5 ], 6 ]
repeat(3; .[1])
4

repeat: Can build arrays 2 levels deep.
"deep"
repeat(2; [ . ])
[ [ "deep" ] ]

repeat: Can build arrays 3 levels deep.
"deep"
repeat(3; [ . ])
[ [ [ "deep" ] ] ]

addition: Can repeatedly add 3.
2
addition(4; 3)
14

addition: Can add -3 twice.
2
addition(2; -3)
-4

addition: Can repeatedly add a character.
"a"
addition(2; "b")
"abb"

addition: Can repeatedly add a string.
"a"
addition(2; "bc")
"abcbc"

addition: Can repeatedly add arrays.
[ "a" ]
addition(2; [ "b" ])
[ "a", "b", "b" ]

subtract: Can repeatedly subtract 3.
14
subtract(4; 3)
2

subtract: Can subtract -3 twice.
14
subtract(2; -3)
20

multiply: Can emulate pow.
1
multiply(10; 2)
1024

multiply: Can deep merge objects.
{ "a": { "c": 100, "d": [ 101, 102 ], "e": 103 }, "b": 104 }
multiply(1; { "a": { "c": 200, "d": [ 201, 202 ] }, "c": "b" })
{ "a": { "c": 200, "d": [ 201, 202 ], "e": 103 }, "b": 104, "c": "b" }

multiply: Can deep merge objects ten times, which makes no sense.
{ "a": { "c": 100, "d": [ 101, 102 ], "e": 103 }, "b": 104 }
multiply(10; { "a": { "c": 200, "d": [ 201, 202 ] }, "c": "b" })
{ "a": { "c": 200, "d": [ 201, 202 ], "e": 103 }, "b": 104, "c": "b" }

divide: Can repeat division.
81
divide(2; 3)
9

sqrt: Can repeat sqrt.
81
sqrt(2)
3

addition: Can repeatedly add deep numbers.
1
addition(2; addition(3; 4))
40

addition: Can repeatedly add deep strings.
"a"
addition(2; addition(2; "b"))
"aabbaabbbb"

repeat: Can create objects within each other. Does this have a use?
"deep"
repeat(2; { "a": repeat(2; { "b": . }) } )
{ "a": { "b": { "b": { "a": { "b": { "b": "deep" } } } } } }

repeat: Fibonacci 0
[ 0, 1 ]
repeat(0; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
0

repeat: Fibonacci 1
[ 0, 1 ]
repeat(1; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
1

repeat: Fibonacci 2
[ 0, 1 ]
repeat(2; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
1

repeat: Fibonacci 3
[ 0, 1 ]
repeat(3; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
2

repeat: Fibonacci 4
[ 0, 1 ]
repeat(4; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
3

repeat: Fibonacci 5
[ 0, 1 ]
repeat(5; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
5

repeat: Fibonacci 6
[ 0, 1 ]
repeat(6; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
8

repeat: Fibonacci 100
[ 0, 1 ]
repeat(100; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
354224848179262000000

repeat: Fibonacci 101
[ 0, 1 ]
repeat(101; [ .[1], ( .[0] + .[1] ) ] ) | .[0]
573147844013817200000
EOF

function testAllFourLineTests () {
	echo "$fourLineTests" | runAllFourLineTests
}


# Run tests above automatically.
# Custom tests can be added by adding new function with a name that starts with "test": function testSomething () { some test code; }
source "${BASH_SOURCE%/*}/test-runner.sh"
