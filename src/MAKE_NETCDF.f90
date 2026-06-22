program make_netcdf
implicit none
filename = 'tmp_test.bin'
write (*,*) 'Reading from file: ', trim(filename)
open (10, file = trim(filename), form = 'unformatted', status = 'old')
read (10) tmp
close (10)
write (*,*) 'Finished reading from file: ', trim(filename)
end program make_netcdf
