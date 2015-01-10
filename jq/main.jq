def repeat($n; f):
	reduce range($n) as $i (
		.;
		f
	);

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
