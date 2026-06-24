program make_netcdf
use netcdf
implicit none
integer, parameter :: nlon = 720, nlat = 360
integer, parameter :: nland = 67420
integer, parameter :: ntimes = 1 ! 1460
real, parameter :: fill       = 1.0e20
real, parameter :: zero       = 0.0
real, parameter :: pi         = 3.14159
real, parameter :: larea_base = 1.0e6 * (40075.0 / 720.0) ** 2 ! m2
! Centre of gridbox.
real, dimension (nlon) :: lon
real, dimension (nlat) :: lat
real, dimension (nland,ntimes) :: tmp_test_k
real, dimension (nland) :: pre_test_k
real, allocatable, dimension (:,:) :: NPP_test_k
real, dimension (nlon,nlat) :: tmp_test_grid
real, dimension (nlon,nlat) :: pre_test_grid
real, dimension (nlon,nlat) :: NPP_test_grid
character (len = 200) :: filename, filename2, dir_home
real :: larea, lon_w, lat_w
real, allocatable, dimension (:) :: NPP_ann
integer, dimension (2) :: dimids_two
integer, dimension (nland) :: xk, yk
integer :: ncid, lon_dimid, lat_dimid
integer :: lon_varid, lat_varid, k, kyr, syr, eyr, nyr, iyr
integer :: varid_tmp_test_grid
integer :: varid_pre_test_grid
integer :: varid_NPP_test_grid
!----------------------------------------------------------------------!
filename = 'namelist.txt'
open (10, file = filename, status = 'old')
read (10,*) dir_home
close (10)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/exec/driver.txt'
open(10, file = filename, status = 'old')
read (10,*) syr
read (10,*) eyr
close (10)
nyr = eyr - syr + 1
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/tmp_test.bin'
write (*,*) 'Reading from file: ', trim(filename)
open (10, file = trim(filename), form = 'unformatted', status = 'old')
read (10) tmp_test_k
close (10)
write (*,*) 'Finished reading from file: ', trim(filename)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/pre_test.bin'
write (*,*) 'Reading from file: ', trim(filename)
open (10, file = trim(filename), form = 'unformatted', status = 'old')
read (10) pre_test_k
close (10)
write (*,*) 'Finished reading from file: ', trim(filename)
!----------------------------------------------------------------------!
! Centre lons and lats of 1/2-degree gridboxes.
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
! Find a k
lon_w =  0.1192 ! Cambridge
lat_w = 52.2053 ! Cambridge
do k = 1, nland
  !write (*,*) lon(k), lat(k)
  if ((lon_w>(lon(xk (k))-0.25)) .and. (lon_w<=(lon(xk (k))+0.25))) then
    if ((lat_w>(lat(yk (k))-0.25)) .and. (lat_w<=(lat(yk (k))+0.25))) then
      write (*,*) 'Found k = ', k, lon_w, lat_w, lon(xk (k)), lat(yk (k))
    end if
  end if
end do
!----------------------------------------------------------------------!
allocate (NPP_test_k(nland,nyr))
allocate (NPP_ann(nyr))
tmp_test_grid = fill
pre_test_grid = fill
NPP_test_grid = fill
filename = trim(dir_home)//'/HYBRID15/data/NPP_test.bin'
write (*,*) 'Reading from file: ', trim(filename)
open (10, file = trim(filename), form = 'unformatted', status = 'old')
filename2 = trim(dir_home)//'/HYBRID15/data/NPP_ann.txt'
open (20, file = trim(filename2), status = 'unknown')
NPP_ann = zero
do kyr = syr, eyr
  iyr = kyr - syr + 1
  read (10) NPP_test_k (:,iyr)
  do k = 1, nland
    if (kyr == eyr) then
      tmp_test_grid (xk (k), yk (k)) = tmp_test_k (k,1)
      pre_test_grid (xk (k), yk (k)) = pre_test_k (k)
      NPP_test_grid (xk (k), yk (k)) = NPP_test_k (k,iyr)
    end if
    larea = cos (lat (yk (k)) * pi / 180.0) * larea_base
    NPP_ann (iyr) = NPP_ann (iyr) + larea * NPP_test_k (k,iyr)
  end do
  write (*,*) kyr, 'NPP_ann = ', NPP_ann (iyr) / 1.0e15
  write (20,*) kyr, NPP_ann (iyr) / 1.0e15
end do ! kyr
close (10)
close (20)
write (*,*) 'Finished reading from file: ', trim(filename)
write (*,*) 'Finished write to file: ', trim(filename2)
!----------------------------------------------------------------------!
filename = trim(dir_home)//'/HYBRID15/data/clm_test.nc'
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
call check (nf90_def_var (ncid, 'pre_test', nf90_float, &
            dimids_two, varid_pre_test_grid))
call check (nf90_def_var (ncid, 'NPP_test', nf90_float, &
            dimids_two, varid_NPP_test_grid))
!----------------------------------------------------------------------!
call check (nf90_put_att (ncid, lon_varid, 'units' , 'degrees_east'))
call check (nf90_put_att (ncid, lat_varid, 'units' , 'degrees_north'))
call check (nf90_put_att (ncid, varid_tmp_test_grid, 'units', 'K'))
call check (nf90_put_att (ncid, varid_pre_test_grid, 'units', 'mm/6hr'))
call check (nf90_put_att (ncid, varid_NPP_test_grid, 'units', 'kg[DM]/m2/yr'))
call check (nf90_put_att (ncid, varid_tmp_test_grid, '_FillValue',fill))
call check (nf90_put_att (ncid, varid_pre_test_grid, '_FillValue',fill))
call check (nf90_put_att (ncid, varid_NPP_test_grid, '_FillValue',fill))
!----------------------------------------------------------------------!
call check (nf90_enddef (ncid))
!----------------------------------------------------------------------!
call check (nf90_put_var (ncid, lon_varid, lon))
call check (nf90_put_var (ncid, lat_varid, lat))
call check (nf90_put_var (ncid, varid_tmp_test_grid, tmp_test_grid))
call check (nf90_put_var (ncid, varid_pre_test_grid, pre_test_grid))
call check (nf90_put_var (ncid, varid_NPP_test_grid, NPP_test_grid))
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
