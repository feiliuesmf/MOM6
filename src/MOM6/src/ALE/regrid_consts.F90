!> Contains constants for interpreting input parameters that control regridding.
module regrid_consts

! This file is part of MOM6. See LICENSE.md for the license.

use MOM_error_handler, only : MOM_error, FATAL
use MOM_string_functions, only : uppercase

implicit none ; public

! List of regridding types
integer, parameter :: REGRIDDING_LAYER     = -1     !< Layer mode
integer, parameter :: REGRIDDING_ZSTAR     = 0      !< z* coordinates
integer, parameter :: REGRIDDING_RHO       = 1      !< Target interface densities
integer, parameter :: REGRIDDING_SIGMA     = 2      !< Sigma coordinates
integer, parameter :: REGRIDDING_ARBITRARY = 3      !< Arbitrary coordinates
integer, parameter :: REGRIDDING_HYCOM1    = 4      !< Simple HyCOM coordinates without BBL
integer, parameter :: REGRIDDING_SLIGHT    = 5      !< Stretched coordinates in the
                                                    !! lightest water, isopycnal below
character(len=5), parameter :: REGRIDDING_LAYER_STRING = "LAYER"   !< Layer string
character(len=2), parameter :: REGRIDDING_ZSTAR_STRING = "Z*"      !< z* string
character(len=3), parameter :: REGRIDDING_RHO_STRING   = "RHO"     !< Rho string
character(len=5), parameter :: REGRIDDING_SIGMA_STRING = "SIGMA"   !< Sigma string
character(len=6), parameter :: REGRIDDING_HYCOM1_STRING = "HYCOM1" !< Hycom string
character(len=6), parameter :: REGRIDDING_SLIGHT_STRING = "SLIGHT" !< Hybrid S-rho string
character(len=5), parameter :: DEFAULT_COORDINATE_MODE = REGRIDDING_LAYER_STRING !< Default coordinate mode

interface coordinateUnits
  module procedure coordinateUnitsI
  module procedure coordinateUnitsS
end interface

contains

!> Parse a string parameter specifying the coordinate mode and
!! return the appropriate enumerated integer
function coordinateMode(string)
  integer :: coordinateMode !< Enumerated integer indicating coordinate mode
  character(len=*), intent(in) :: string !< String to indicate coordinate mode
  select case ( uppercase(trim(string)) )
    case (trim(REGRIDDING_LAYER_STRING)); coordinateMode = REGRIDDING_LAYER
    case (trim(REGRIDDING_ZSTAR_STRING)); coordinateMode = REGRIDDING_ZSTAR
    case (trim(REGRIDDING_RHO_STRING));   coordinateMode = REGRIDDING_RHO
    case (trim(REGRIDDING_SIGMA_STRING)); coordinateMode = REGRIDDING_SIGMA
    case (trim(REGRIDDING_HYCOM1_STRING)); coordinateMode = REGRIDDING_HYCOM1
    case (trim(REGRIDDING_SLIGHT_STRING)); coordinateMode = REGRIDDING_SLIGHT
    case default ; call MOM_error(FATAL, "coordinateMode: "//&
       "Unrecognized choice of coordinate ("//trim(string)//").")
  end select
end function coordinateMode

!> Returns a string with the coordinate units associated with the
!! enumerated integer,
function coordinateUnitsI(coordMode)
  character(len=16) :: coordinateUnitsI !< Units of coordinate
  integer, intent(in) :: coordMode !< Coordinate mode
  select case ( coordMode )
    case (REGRIDDING_LAYER); coordinateUnitsI = "kg m^-3"
    case (REGRIDDING_ZSTAR); coordinateUnitsI = "m"
    case (REGRIDDING_RHO);   coordinateUnitsI = "kg m^-3"
    case (REGRIDDING_SIGMA); coordinateUnitsI = "Non-dimensional"
    case (REGRIDDING_HYCOM1); coordinateUnitsI = "m"
    case (REGRIDDING_SLIGHT); coordinateUnitsI = "m"
    case default ; call MOM_error(FATAL, "coordinateUnts: "//&
       "Unrecognized coordinate mode.")
  end select
end function coordinateUnitsI

!> Returns a string with the coordinate units associated with the
!! string defining the coordinate mode.
function coordinateUnitsS(string)
  character(len=16) :: coordinateUnitsS !< Units of coordinate
  character(len=*), intent(in) :: string !< Coordinate mode
  integer :: coordMode
  coordMode = coordinateMode(string)
  coordinateUnitsS = coordinateUnitsI(coordMode)
end function coordinateUnitsS

end module regrid_consts
