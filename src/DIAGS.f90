subroutine DIAGS
!----------------------------------------------------------------------!
use VARS
!----------------------------------------------------------------------!
implicit none
!----------------------------------------------------------------------!
! Global field of annual precipitation (mm/yr).
!----------------------------------------------------------------------!
real, dimension (nland) :: pre_ann
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/tmp_test.bin'
write (*,*) 'Writing to file: ', trim(filename)
open (20, file = trim(filename), form = 'unformatted', status = 'unknown')
write (20) tmp (:,1)
close (20)
write (*,*) 'Finished writing to file: ', trim(filename)
!----------------------------------------------------------------------!
pre_ann = zero
do k = 1, nland
  pre_ann (k) = sum (pre(k,:))
end do
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/pre_test.bin'
write (*,*) 'Writing to file: ', trim(filename)
open (20, file = trim(filename), form = 'unformatted', status = 'unknown')
write (20) pre_ann ! Will just be last year
close (20)
write (*,*) 'Finished writing to file: ', trim(filename)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/NPP_test.bin'
write (*,*) 'Writing to file: ', trim(filename)
open (20, file = trim(filename), form = 'unformatted', status = 'unknown')
do iyr = 1, nyr
  write (20) NPP (:,iyr)
end do
close (20)
write (*,*) 'Finished writing to file: ', trim(filename)
!----------------------------------------------------------------------!
end subroutine DIAGS
