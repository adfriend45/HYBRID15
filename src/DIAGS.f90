subroutine DIAGS
use VARS
implicit none
filename = 'tmp_test.bin'
write (*,*) 'Writing to file: ', trim(filename)
open (20, file = trim(filename), form = 'unformatted', status = 'unknown')
write (20) tmp (1,:)
close (20)
write (*,*) 'Finished writing to file: ', trim(filename)
end subroutine DIAGS
