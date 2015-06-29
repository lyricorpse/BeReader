!=========================================================================================
! Purpose: Read precalculated binary background error corvariance file
!          in GSI and modify it as you want.
! Version: 0.1
! Author: Feng Zhu, feng.zhu@wisc.edu
! Copyright: BSD
!=========================================================================================

program bereader
    implicit none
    !-------------------------------------------------------------------------------------
    ! settings
    !-------------------------------------------------------------------------------------
    integer, parameter :: i_kind = selected_int_kind(8) ! 1=byte, 4=short, 8=long, 16=llong
    integer, parameter :: r_kind = selected_real_kind(6) ! 6=single, 15=double, 20=quad

    ! for modifying
    ! real(r_kind) :: coeff = 1
    real(r_kind) :: coeff = .5
    !-------------------------------------------------------------------------------------

    character(len=*), parameter :: file_dir = '/data/users/fzhu/Tools/comGSI_v3.3_large_nmsgmax/fix/Big_Endian/'
    character(len=*), parameter :: file_name = 'nam_nmmstat_na.gcv'
    ! character(len=*), parameter :: file_name = 'nam_glb_berror.f77.gcv'
    character(len=*), parameter :: file_path = file_dir//file_name

    integer(i_kind) :: msig, mlat

    integer(i_kind) :: inerr = 22

    !-------------------------------------------------------------------------------------
    ! for reading 'berror_bal_reg'
    !-------------------------------------------------------------------------------------
    real(r_kind), dimension(:), allocatable ::  clat_avn, sigma_avn
    real(r_kind), dimension(:, :), allocatable :: wgv_avn ,bv_avn
    real(r_kind), dimension(:, :, :), allocatable :: agv_avn
    !-------------------------------------------------------------------------------------

    !-------------------------------------------------------------------------------------
    ! for reading 'berror_bal_reg'
    !-------------------------------------------------------------------------------------
    character(len=5) :: varshort
    character(len=256) :: var
    integer(i_kind) :: isig, istat
    real(r_kind),dimension(:, :), allocatable ::  corqq_avn
    real(r_kind), dimension(:, :), allocatable :: corz_avn, hwll_avn, vztdq_avn

    !-------------------------------------------------------------------------------------

    integer k

    call system('cp '//file_path//' ./input') ! backup the orginal file in the input dir
    call system('rm -f ./output/'//file_name) ! clean up the output dir

    !=====================================================================================
    ! Read 'berror_stats'.
    !=====================================================================================
    write(*, *)
    write(*, *) '-------------------'
    write(*, *) 'START: BE reader...'
    write(*, *) '-------------------'
    write(*, *)
    write(*, *) 'BE file path: ', file_path
    write(*, *)

    ! berror_get_dims OUT: msig, mlat
    open(99, file='./output/'//file_name, form='unformatted', status='replace', convert='big_endian')
    open(inerr, file='./input/'//file_name, form='unformatted', status='old', convert='big_endian')
    rewind inerr
    read(inerr) msig, mlat
    write(*, *) 'msig: ', msig
    write(*, *) 'mlat: ', mlat
    write(*, *)
    write(99) msig, mlat

    ! berror_read_bal_reg IN: msig, mlat; OUT: agvi, wgvi, bvi
    allocate(clat_avn(mlat))
    allocate(sigma_avn(1:msig))
    allocate(agv_avn(0:mlat+1, 1:msig, 1:msig))
    allocate(bv_avn(0:mlat+1, 1:msig), wgv_avn(0:mlat+1, 1:msig))

    read(inerr) clat_avn, (sigma_avn(k), k=1,msig)
    read(inerr) agv_avn, bv_avn, wgv_avn
    write(*, *) 'Reading bal done.'
    write(*, *)
    write(99) clat_avn, (sigma_avn(k), k=1,msig)
    write(99) agv_avn, bv_avn, wgv_avn

    ! berror_read_wgt_reg IN: msig, mlat; OUT: corz, corp, hwll, hwllp, vz, rlsig
    read: do
        read(inerr, iostat=istat) varshort, isig
        write(*, *) 'varshort: ', varshort
        write(*, *) 'isig: ', isig
        var = varshort
        if (istat /= 0) exit
        write(99, iostat=istat) varshort, isig
        allocate(corz_avn(1:mlat, 1:isig))
        allocate(hwll_avn(0:mlat+1, 1:isig))
        allocate(vztdq_avn(1:isig, 0:mlat+1))
        if (var/='q') then
            read(inerr) corz_avn
            write(99) corz_avn*coeff
        else
            allocate ( corqq_avn(1:mlat,1:isig) )
            read(inerr) corz_avn, corqq_avn
            write(99) corz_avn*coeff, corqq_avn*coeff
        end if

        read(inerr) hwll_avn
        write(99) hwll_avn

        if (isig>1) then
            read(inerr) vztdq_avn
            write(99) vztdq_avn
        end if

        ! write(*, *) 'corz_avn: ', corz_avn

        deallocate ( corz_avn )
        deallocate ( hwll_avn )
        deallocate ( vztdq_avn )
        if (var=='q') deallocate ( corqq_avn )
    enddo read
    close(inerr)
    close(99)

    deallocate(clat_avn,sigma_avn)
    deallocate(agv_avn,bv_avn,wgv_avn)

    write(*, *)
    write(*, *) 'Reading wgt done.'
    write(*, *)

    write(*, *) '-------------------------------'
    write(*, *) 'DONE: Reading BE file complete!'
    write(*, *) '-------------------------------'
    write(*, *)
    close(inerr)
    !=====================================================================================

end program bereader
