compile("real_api")
compile("stdio_api")
compile("stdlib_api")

use real_api as real
use stdlib_api as lib
use stdio_api as io

func main <> () {
	real.number ref numbers

	numbers <- call(real.initialize_real_set43, "1", "2", 0)
	
	call(numbers-->printnthln, numbers, 0)
	call(numbers-->printnthln, numbers, 1)
	call(numbers-->println, addr numbers-->set[0].dn)
	call(numbers-->println, addr numbers-->set[1].dn)
	call(io.printf, "numbers are: %s %s\n", numbers-->set[0].string, numbers-->set[1].string)
	call(real.deinitialize_real_set43, numbers)
}