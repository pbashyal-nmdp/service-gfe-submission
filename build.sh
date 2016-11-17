#!/bin/bash
#################################################################################
# 	Copyright (c) 2015 National Marrow Donor Program (NMDP)
#
# 	This library is free software; you can redistribute it and/or modify it
# 	under the terms of the GNU Lesser General Public License as published
# 	by the Free Software Foundation; either version 3 of the License, or (at
# 	your option) any later version.
#
# 	This library is distributed in the hope that it will be useful, but WITHOUT
# 	ANY WARRANTY; with out even the implied warranty of MERCHANTABILITY or
# 	FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# 	License for more details.
#
# 	You should have received a copy of the GNU Lesser General Public License
# 	along with this library;  if not, write to the Free Software Foundation,
# 	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA.
#
# 	> http://www.gnu.org/licenses/lgpl.html
#################################################################################
set -e

working=`pwd`
PATH=$PATH:${working}/hap1.1:hap1.1

#  ** Noted issue with hap1.1.jar **   #
# Something odd with hap1.1.jar renaming
mv -i GFE_Submission gfe_submission

# Install GFE_Submission and launch
cd gfe_submission
sudo perl Makefile.PL
make test
if [ "$?" != "0" ]; then
	exit $?
fi
sudo make install

# Run service
plackup -D -E deployment -s Starman -p 5000 -a bin/app.pl

# Install perl clients
cd ../client-perl
sudo perl Makefile.PL
make test
if [ "$?" != "0" ]; then
	exit $?
fi
sudo make install

