program make_netcdf
use netcdf
implicit none
integer, parameter :: nlon = 720, nlat = 360
integer, parameter :: nland = 67420
integer, parameter :: ntimes = 1 ! 1460
real, parameter :: fill = 1.0e20
! Centre of gridbox.
real, dimension (nlon) :: lon
real, dimension (nlat) :: lat
real, dimension (nland,ntimes) :: tmp_test_k
real, dimension (nlon,nlat) :: tmp_test_grid
character (len = 200) :: filename, dir_home
integer, dimension (2) :: dimids_two
integer, dimension (nland) :: xk, yk
integer :: ncid, lon_dimid, lat_dimid, varid_tmp_test_grid
integer :: lon_varid, lat_varid, k
filename = 'namelist.txt'
open (10, file = filename, status = 'old')
read (10,*) dir_home
close (10)
filename = trim(dir_home)//'/HYBRID15/data/tmp_test.bin'
write (*,*) 'Reading from file: ', trim(filename)
open (10, file = trim(filename), form = 'unformatted', status = 'old')
read (10) tmp_test_k
close (10)
write (*,*) 'Finished reading from file: ', trim(filename)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/lonslats.bin'
open(10,file=trim(filename),form='unformatted',status='old')
read (10) lon, lat
close (10)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/coords.bin'
open(10,file=filename,form='unformatted',status='old')
read (10) xk, yk
close (10)
!----------------------------------------------------------------------!
tmp_test_grid = fill
do k = 1, nland
  tmp_test_grid (xk (k), yk (k)) = tmp_test_k (k,1)
  write (*,*) xk(k),yk(k),tmp_test_k(k,1)
end do ! k
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/tmp_test.nc'
call check (nf90_create (trim(filename), cmode = nf90_clobber, &
  ncid = ncid))
!----------------------------------------------------------------------!
call check (nf90_def_dim (ncid, 'longitude', nlon, lon_dimid))
call check (nf90_def_dim (ncid, 'latitude' , nlat, lat_dimid))
!----------------------------------------------------------------------!
call check (nf90_def_var (ncid, 'longitude', nf90_float, lon_dimid, &
            lon_varid))
call check (nf90_def_var (ncid, 'latitude' , nf90_float, lat_dimid, &
            lat_varid))
dimids_two = (/ lon_dimid, lat_dimid /)
!----------------------------------------------------------------------!
call check (nf90_def_var (ncid, 'tmp_test', nf90_float, &
            dimids_two, varid_tmp_test_grid))
!----------------------------------------------------------------------!
call check (nf90_put_att (ncid, lon_varid, 'units' , 'degrees_east'))
call check (nf90_put_att (ncid, lat_varid, 'units' , 'degrees_north'))
call check (nf90_put_att (ncid, varid_tmp_test_grid, 'units', 'K'))
call check (nf90_put_att (ncid, varid_tmp_test_grid, '_FillValue',fill))
!----------------------------------------------------------------------!
call check (nf90_enddef (ncid))
!----------------------------------------------------------------------!
call check (nf90_put_var (ncid, lon_varid, lon))
call check (nf90_put_var (ncid, lat_varid, lat))
call check (nf90_put_var (ncid, varid_tmp_test_grid, tmp_test_grid))
!----------------------------------------------------------------------!
call check (nf90_close (ncid))
!----------------------------------------------------------------------!
contains
 subroutine check ( status )

 integer, intent ( in ) :: status
 if (status /= nf90_noerr) then
  print *, trim (nf90_strerror( status ))
  stop "Stopped"
 end if
 end subroutine check
end program make_netcdf
