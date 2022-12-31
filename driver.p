compile("real_api")
compile("stdio_api")
compile("stdlib_api")

use real_api as real
use stdlib_api as lib
use stdio_api as io

func main <> () {
	real.number ref numbers

	numbers <- ::(real.initialize_real_set43, "1.1272172312", "2.1312123787", 0)
	
	::(numbers-->printnthln, numbers, 0)
	::(numbers-->printnthln, numbers, 1)
	::(numbers-->println, addr numbers-->set[0].dn)
	::(numbers-->println, addr numbers-->set[1].dn)
	::(io.printf, "numbers are: %s %s\n", numbers-->set[0].string, numbers-->set[1].string)
	::(real.deinitialize_real_set43, numbers)
}