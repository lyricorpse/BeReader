#!/usr/bin/env python3

# ===============================================================================
# Purpose: Read precalculated binary background error corvariance file
#          in GSI and modify it as you want.
# Version: 0.1
# Author: Feng Zhu, feng.zhu@wisc.edu
# Copyright: BSD
# ===============================================================================

import os
import sys
import numpy as np
import click

# ===============================================================================
# Settings
# -------------------------------------------------------------------------------

file_dir = '/data/users/fzhu/Tools/comGSI_v3.3_large_nmsgmax/fix/Big_Endian'
file_name = 'nam_nmmstat_na.gcv'

# ===============================================================================

file_path = os.path.join(file_dir, file_name)


def main():
    click.echo(
        click.style('Start BE Reader...', fg='green')
    )
    click.echo()
    if os.path.exists(file_path):
        click.echo(
            click.style('BE file path: ', fg='green') + file_path
        )
    else:
        click.echo(
            click.style('BE file path: ', fg='red') + file_path
        )
        sys.exit('ERROR: The BE file path is incorrect!')

    # ===========================================================================
    # Start reading data from the binary file.
    # ---------------------------------------------------------------------------

    # get_dims
    f = open(file_path, 'rb')
    msig = np.fromfile(f, dtype='uint32', count=1)
    mlat = np.fromfile(f, dtype='uint32', count=1)
    mlon = np.fromfile(f, dtype='uint32', count=1)
    print('msig:', msig, 'mlat:', mlat, 'mlon:', mlon)
    f.close()

    # read_bal
    f = open(file_path, 'rb')
    nsigstat = np.fromfile(f, dtype='uint32', count=1)
    nlatstat = np.fromfile(f, dtype='uint32', count=1)
    print('nsigstat:', nsigstat, 'nlatstat:', nlatstat)

    agvin = np.fromfile(f, dtype='float32', count=1)
    bvin = np.fromfile(f, dtype='float32', count=1)
    wgvin = np.fromfile(f, dtype='float32', count=1)
    print('agvin:', agvin, 'bvin:', bvin, 'wgvin:', wgvin)
    f.close()

    # ===========================================================================


if __name__ == '__main__':
    main()
