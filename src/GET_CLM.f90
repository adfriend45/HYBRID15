subroutine GET_CLM
use VARS
implicit none
!----------------------------------------------------------------------!
! Set character string of year (CE).
!----------------------------------------------------------------------!
write (cyr, '(i4)') kyr
!----------------------------------------------------------------------!
! Read a year of 6-hr half-degree surface air temperaures (K).
!----------------------------------------------------------------------!
filename = '/rds/user/adf10/rds-mb425-geogscratch/adf10/&
 &TRENDYGCB2024/binaries/tmp/crujra.v2.4.5d.tmp.'//cyr//&
 &'.365d.noc.bin'
open (10, file = filename, form = 'unformatted', status = 'old')
read (10) tmp
close (10)
write (*,*) tmp(1,:)
end subroutine GET_CLM
