subroutine NPP_Lieth
use VARS
implicit none
real, parameter :: one  = 1.0
real, parameter :: tf  = 273.15
integer, parameter :: k_w = 43386
real :: y_tmp
real :: y_pre
real :: MAT
real :: PPT
MAT = sum (tmp (k,:)) / size (tmp (k,:)) - tf
PPT = sum (pre (k,:))
if (k == k_w) then
  write (*,*) kyr, sum (tmp (k,:)) / size (tmp (k,:)) - tf, &
            sum (pre (k,:))
end if
!----------------------------------------------------------------------!
! Temperature-limited NPP                                  (g[DM]/m2/yr)
! Equation from p. 325 of Lieth ().
!----------------------------------------------------------------------!
y_tmp = 3000.0 / (one + exp (1.315 - 0.119 * MAT))
!----------------------------------------------------------------------!
! Precipitation-limited NPP                                (g[DM]/m2/yr)
! Equation from p. 325 of Lieth ().
!----------------------------------------------------------------------!
y_pre = 3000.0 * (one - exp (-0.000664 * PPT))
!----------------------------------------------------------------------!
NPP (k,iyr) = min (y_tmp, y_pre)
NPP (k,iyr) = max(zero,NPP(k,iyr))
NPP (k,iyr) = min(3000.0,NPP(k,iyr))
!----------------------------------------------------------------------!
end subroutine NPP_Lieth
