<p align="center">
  <img src="https://rawgit.com/joelpurra/jqnpm/master/resources/logotype/penrose-triangle.svg" alt="jqnpm logotype, a Penrose triangle" width="100" />
</p>

# [jq-dry](https://github.com/joelpurra/jq-dry)

Don't repeat yourself!

Apply a filter `f` to its own output `n` times. Can be used to apply filters `n` recursive levels, to build deep objects and for arithmetic.

This is a package for the command-line JSON processor [`jq`](https://stedolan.github.io/jq/). Install the package in your jq project/package directory with [`jqnpm`](https://github.com/joelpurra/jqnpm):

```bash
jqnpm install joelpurra/jq-dry
```



## Usage


```jq
import "joelpurra/jq-dry" as DRY;

# The general case: 'n' is the number of repetitions:
# DRY::repeat(n; f)
"YO" | DRY::repeat(3; . + "LO")                           # "YOLOLOLO"
"LO" | DRY::repeat(3; "YO" + .)                           # "YOYOYOLO"


# Can recurse into objects 'n' levels deep.
{ "a": { "a": { "a": "deep" } } } | DRY::repeat(2; .a)    # { "a": "deep" }
{ "a": { "a": { "a": "deep" } } } | DRY::repeat(3; .a)    # "deep"

# Can build objects 'n' levels deep.
"deep" | DRY::repeat(2; { a: . })                         # { "a": { "a": "deep" } }
"deep" | DRY::repeat(3; { a: . })                         # { "a": { "a": { "a": "deep" } } }


# Can recurse into arrays 'n' levels deep.
[ 1, [ 2, [ 3, 4 ], 5 ], 6 ] | DRY::repeat(2; .[1])       # [ 3, 4 ]
[ 1, [ 2, [ 3, 4 ], 5 ], 6 ] | DRY::repeat(3; .[1])       # 4

# Can build arrays 'n' levels deep.
"deep" | DRY::repeat(2; [ . ])                            # [ [ "deep" ] ]
"deep" | DRY::repeat(3; [ . ])                            # [ [ [ "deep" ] ] ]



# Shortcuts for some jq builtins, and what they make sense to use with:

# objA | DRY::addition(n; objB) for numbers, arrays, strings.
# Also works as '+' for objects, but it makes no sense to repeat it.
# The name is 'addition' because 'add' is already a jq builtin.
2 | DRY::addition(4; 3)                           # 14
"a" | DRY::addition(2; "bc")                      # "abcbc"
[ "a" ] | DRY::addition(2; [ "b" ])               # [ "a", "b", "b" ]

# DRY::subtract(n; obj) for numbers.
# Also works as '-' for arrays, but it makes no sense to repeat it.
#  Effectively: numA - (n times numB).
14 | DRY::subtract(4; 3)                     # 2

# numA | DRY::multiply(n; numB) for numbers.
# Also works as '*' for objects, but it makes no sense to repeat it.
#  Effectively: numA times (numB to the power of n).
1 | DRY::multiply(10; 2)                     # 1024

# numA | DRY::divide(n; numB) for numbers.
#  Effectively: numA divided with (numB to the power of n).
81 | DRY::divide(2; 3)                       # 9

# numA | DRY::sqrt(n; numB) for numbers.
# Effectively: sqrt(numA) to the power of n.
# Equals: (numA to the power of 1/2) to the power of n.
81 | DRY::sqrt(2)                            # 3



# Combining repetitions can be fun, if somewhat complex and confusing.
# More -- and better -- examples welcome!

1 | DRY::addition(2; DRY::addition(3; 4))         # 40 (1 + (((1 + 4) + 4) + 4) + (((1 + (((1 + 4) + 4) + 4) + 4) + 4) + 4))
"a" | DRY::addition(2; DRY::addition(2; "b"))    # "aabbaabbbb" ("a" + (("a" + "b") + "b") + (("a" + (("a" + "b") + "b") + "b") + "b"))

# Fibonacci number 'n' using repeat.
[ 0, 1 ] | repeat(0; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 0
[ 0, 1 ] | repeat(1; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 1
[ 0, 1 ] | repeat(2; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 1
[ 0, 1 ] | repeat(3; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 2
[ 0, 1 ] | repeat(4; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 3
[ 0, 1 ] | repeat(5; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 5
[ 0, 1 ] | repeat(6; [ .[1], ( .[0] + .[1] ) ] ) | .[0]    # 8

# Or the equivalent function:
def fib($n):
	[ 0, 1 ]
	| repeat(
		$n;
		[
			.[1],
			(
				.[0]
				+ .[1]
			)
		]
	)
	| .[0];
```



---

## License
Copyright (c) 2015 Joel Purra <http://joelpurra.com/>
All rights reserved.

When using **jq-dry**, comply to the MIT license. Please see the LICENSE file for details.
