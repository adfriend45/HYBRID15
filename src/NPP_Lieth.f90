subroutine NPP_Lieth
use VARS
implicit none
real, parameter :: one = 1.0
real, parameter :: tf  = 273.15
real :: y_tmp
real :: y_pre
real :: MAT
real :: PPT
MAT = sum (tmp (k,:)) / size (tmp (k,:)) - tf
PPT = sum (pre (k,:))
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
NPP (k,iyr)= min (y_tmp, y_pre)
!----------------------------------------------------------------------!
end subroutine NPP_Lieth
