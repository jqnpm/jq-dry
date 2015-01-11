def iterate($n; f):
	reduce range($n) as $i (
		[
			-1,
			.
		];
		.[0] = $i
		| .[1] = f
	);

def repeat($n; f):
	iterate($n; .[1] | f)
	| .[1];

# Wrap some jq built-ins which make sense to repeat.
#
# The name 'addition' isn't great, but 'add' is a jq built-in.
# TODO: the nomenclature is not consistent.
def addition($n; f):
	repeat($n; . + f);

def subtract($n; f):
	repeat($n; . - f);

def multiply($n; f):
	repeat($n; . * f);

def divide($n; f):
	repeat($n; . / f);

def sqrt($n):
	repeat($n; . | sqrt);
