F90 = mpif90 -I/usr/local/software/spack/spack-views/.rhel8-icelake-202110272/uxqqj4xcjrltatqgtuoi2hp46uabtzom/intel-oneapi-mpi-2021.4.0/intel-2021.4.0/kypfgtnfzspxoby7tqy7yt6ykejpwk5n/mpi/2021.4.0/

FFLAGS = -O2
LDFLAGS = -lnetcdff

SRC = \
	HYBRID15.f90	\
	GET_CLM.f90	\
	DIAGS.f90	\
	PARAMS.f90	\
	VARS.f90

OBJ = $(SRC:.f90=.o)

HYBRID15.exe : $(OBJ)
	$(F90) $(FFLAGS) -o HYBRID15.exe $(OBJ) $(LDFLAGS)

# Main routine
HYBRID15.o : GET_CLM.o DIAGS.o VARS.o HYBRID15.f90
	$(F90) $(FFLAGS) -c HYBRID15.f90

# Subroutines
GET_CLM.o : VARS.o GET_CLM.f90
	$(F90) $(FFLAGS) -c GET_CLM.f90

DIAGS.o : VARS.o DIAGS.f90
	$(F90) $(FFLAGS) -c DIAGS.f90

# Modules
PARAMS.o : PARAMS.f90
	$(F90) $(FFLAGS) -c PARAMS.f90

VARS.o : PARAMS.o VARS.f90
	$(F90) $(FFLAGS) -c VARS.f90
