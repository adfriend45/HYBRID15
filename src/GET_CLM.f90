subroutine GET_CLM
!----------------------------------------------------------------------!
use VARS
!----------------------------------------------------------------------!
implicit none
!----------------------------------------------------------------------!
! Set character string of year (CE).
!----------------------------------------------------------------------!
write (cyr, '(i4)') kyr
!----------------------------------------------------------------------!
! Read a year of 6-hr half-degree surface air temperatures (K).
!----------------------------------------------------------------------!
filename = '/rds/user/adf10/rds-mb425-geogscratch/adf10/&
 &trendyv14-gcb2025-input/binaries/tmp/crujra.v3.5d.tmp.'//cyr//&
 &'.365d.noc.bin'
!  filename = '/rds/user/adf10/rds-mb425-geogscratch/adf10/TRENDY2021/&
!   &input/Climate_binaries/'//'crujra.v2.2.5d.tmp.'//&
!   &cyr//'.365d.noc.bin'
open (10, file = filename, form = 'unformatted', status = 'old')
read (10) tmp
close (10)
!----------------------------------------------------------------------!
! Read a year of 6-hr half-degree precipitation (mm/6hr).
!----------------------------------------------------------------------!
filename = '/rds/user/adf10/rds-mb425-geogscratch/adf10/&
 &trendyv14-gcb2025-input/binaries/pre/crujra.v3.5d.pre.'//cyr//&
 &'.365d.noc.bin'
!  filename = '/rds/user/adf10/rds-mb425-geogscratch/adf10/TRENDY2021/&
!   &input/Climate_binaries/'//'crujra.v2.2.5d.pre.'//&
!   &cyr//'.365d.noc.bin'
open (10, file = filename, form = 'unformatted', status = 'old')
read (10) pre
close (10)
!----------------------------------------------------------------------!
end subroutine GET_CLM
