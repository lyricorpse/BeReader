!=========================================================================================
! Purpose: Read precalculated binary background error corvariance file
!          in GSI and modify it as you want.
! Version: 0.1
! Author: Feng Zhu, feng.zhu@wisc.edu
! Copyright: BSD
!=========================================================================================

program bereader
    implicit none
    integer, parameter :: i_kind = selected_int_kind(8) ! 1=byte, 4=short, 8=long, 16=llong
    integer, parameter :: r_kind = selected_real_kind(6) ! 6=single, 15=double, 20=quad

    character(len=*), parameter :: file_dir = '/data/users/fzhu/Tools/comGSI_v3.3_large_nmsgmax/fix/Big_Endian/'
    character(len=*), parameter :: file_name = 'nam_nmmstat_na.gcv'
    ! character(len=*), parameter :: file_name = 'nam_glb_berror.f77.gcv'
    character(len=*), parameter :: file_path = file_dir//file_name

    integer(i_kind), parameter :: nsig=42
    integer(i_kind) :: msig, mlat

    integer(i_kind) :: inerr = 22

    real(r_kind), dimension(:), allocatable ::  clat_avn, sigma_avn
    real(r_kind), dimension(:, :), allocatable :: wgv_avn ,bv_avn
    real(r_kind), dimension(:, :, :), allocatable :: agv_avn

    integer i, j, k, m, m1

    !=====================================================================================
    ! Read 'berror_stats'.
    !=====================================================================================
    write(*, *) 'BE file path: ', file_path

    ! get_dims OUT: msig, mlat
    open(inerr, file=file_path, form='unformatted', status='old', convert='big_endian')
    rewind inerr
    read(inerr) msig, mlat
    write(*, *) 'msig: ', msig
    write(*, *) 'mlat: ', mlat

    ! read_bal IN: msig, mlat; OUT: agvi, wgvi, bvi
    allocate(clat_avn(mlat))
    allocate(sigma_avn(1:msig))
    allocate(agv_avn(0:mlat+1, 1:msig, 1:msig))
    allocate(bv_avn(0:mlat+1, 1:msig), wgv_avn(0:mlat+1, 1:msig))
    write(*, *) 'Allocate done.'

    read(inerr) clat_avn, (sigma_avn(k), k=1,msig)
    read(inerr) agv_avn, bv_avn, wgv_avn
    close(inerr)
    write(*, *) 'Reading done.'
    !=====================================================================================

end program bereader
