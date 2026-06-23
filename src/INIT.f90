subroutine INIT
use VARS
implicit none
integer :: nyr
write (*,*) 'genius'
filename = 'namelist.txt'
open (10, file = filename, status = 'old')
read (10,*) dir_home
close (10)
filename = trim(dir_home)//'/HYBRID15/exec/driver.txt'
open(10, file = filename, status = 'old')
read (10,*) syr
read (10,*) eyr
close (10)
nyr = eyr - syr + 1
allocate (NPP(nland,nyr))
end subroutine INIT
