!======================================================================!
program HYBRID15
use VARS
implicit none
write (*,*) 'genius'
do kyr = 1901, 1901
  call GET_CLM
end do
call DIAGS
end program HYBRID15
!======================================================================!
