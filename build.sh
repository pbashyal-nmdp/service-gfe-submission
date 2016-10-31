#!/usr/bin/env sh
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


cp docker/hap1.0.tar.gz .
tar -xzf hap1.0.tar.gz
sudo chmod a+x hap1.0/hap1.0.jar
wget http://www.clustal.org/omega/clustalo-1.2.3-Ubuntu-x86_64
sudo mv clustalo-1.2.3-Ubuntu-x86_64 hap1.0/clustalo
sudo chmod a+x hap1.0/clustalo

working=`pwd`
export PATH=$PATH:${working}/hap1.0

# Something odd with hap1.0.jar renaming
mv -i GFE_Submission gfe_submission

# Install GFE_Submission and launch
cd gfe_submission
sudo perl Makefile.PL
sudo make test
sudo make install

# Run service
plackup -D -E deployment -s Starman -p 5000 -a bin/app.pl

# Install perl clients
cd ../client-perl
sudo perl Makefile.PL
sudo make test
sudo make install
