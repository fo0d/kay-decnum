compile("libdecnum_api")
compile("decContext_api")
compile("stdio_api")
compile("stdlib_api")
compile("string_api")

use libdecnum_api as real
use stdlib_api as lib
use string_api as str
use stdio_api as io

signature plexus number

plexus numset_t (
	real.decNumber_api.decNumber dn,
	byte string[256]
)

plexus number (
	int size,
	numset_t ref set,
	real.decContext_api.decContext ref context,
	func ref free <> (number ref set),
	//
	// Since the these are lambdas, they need to be prototyped with ::
  // because lambdas use our own ABI
	//
	func ref printnth :: (number ref set, int n),
	func ref printnthln :: (number ref set, int n),
	func ref print :: (real.decNumber_api.decNumber ref dn),
	func ref println :: (real.decNumber_api.decNumber ref dn)
)

//
// The way we process the variable arguments is using our own ABI
// since lambda are NOT linux-ABI specific. 
// Hence the use of :: instead of <>
//

signature func init_real_set43 :: number ref (byte ref args, ...)

//
// If we provide signatures to lambdas then
// it allows us to not cast arguments when calling the lambdas.
//
signature func printnth :: (number ref _ds, int nth)
signature func printnthln :: (number ref _ds, int nth)
signature func print :: (real.decNumber_api.decNumber ref dn)
signature func println :: (real.decNumber_api.decNumber ref dn)

lambda printnth (_ds, nth) <- func {
	number ref ds
	ds <- cast(_ds to number ref)
	call(io.printf, "%s", ds-->set[nth].string)
}

lambda printnthln (_ds, nth) <- func {
	number ref ds
	ds <- cast(_ds to number ref)
	call(io.printf, "%s\n", ds-->set[nth].string)
}

lambda print (_dn) <- func {
	real.decNumber_api.decNumber ref dn
	byte string[256]
	dn <- cast(_dn to real.decNumber_api.decNumber ref)
	call(io.printf, "%s", call(real.decNumber_api.decNumberToString, dn, string))
}

lambda println (_dn) <- func {
	real.decNumber_api.decNumber ref dn
	byte string[256]
	dn <- cast(_dn to real.decNumber_api.decNumber ref)
	call(io.printf, "%s\n", call(real.decNumber_api.decNumberToString, dn, string))
}

//
// Initialize a set of real (decimal) numbers
// with 43 decimal digits.
//
// each subsequent argument is expected to be a string
// represending a decimal numerical value.
//
// the last parameter needs to 0 to signify end of arguments.
//
// Return a vector (array) of those numbers
// each vector node contains the number and 
// its string represendation.
//
func initialize_real_set43 :: number ref (byte ref args, ...) {
	number ref ds
	int ref ref va
	int i <- 0
	int n <- 32
	byte ref s

	closure setup_context <- {
		ds <- cast(call(lib.malloc, capacity of (number)) to number ref)
		ds-->context <- cast(call(lib.malloc, capacity of(real.decContext_api.decContext)) to real.decContext_api.decContext ref)
		call(real.decApiInit.setDECUnits, 43)
  	call(real.decApiInit.setDECflags)
  	call(real.decApiInit.setDECgroupingFlags)
  	call(real.decContext_api.decContextDefault, ds-->context, real.decContext_api.DEC_INIT_BASE)
		ds-->set <- cast(call(lib.malloc, capacity of(numset_t) * n) to numset_t ref)
	}

	closure init_numbers <- {
		va <- cast(addr args to int ref ref)

		while true do {
			s <- cast(ref va to int ref)
			if (not s) then 
				done
			va <- va + 1

			call(str.memmove, ds-->set[i].string, s, call(str.strlen, s)) // gets the null as well
			call(real.decNumber_api.decNumberFromString, addr ds-->set[i].dn, s, ds-->context)

			i <- i + 1

			if i > n then {
				n <- n * 2
				ds-->set <- cast(call(lib.realloc, cast(ds-->set to byte ref), capacity of(numset_t) * n) to numset_t ref)
			}
		}

		ds-->size <- i
	}

	closure init_methods <- {
		ds-->printnth <- printnth
		ds-->printnthln <- printnthln
		ds-->print <- print
		ds-->println <- println
	}

	(setup_context)
	(init_numbers)
	(init_methods)

	return (ds)
}

lambda deinitialize_real_set43(_decset) <- func {
	number ref ds
	ds <- cast(_decset to number ref)
	call(lib.free, cast(ds-->set to byte ref))
	call(lib.free, cast(ds-->context to byte ref))
	call(lib.free, cast(ds to byte ref))
}