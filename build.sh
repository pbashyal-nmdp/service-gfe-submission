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


# cp docker/hap1.0.tar.gz .
# tar -xzf hap1.0.tar.gz
# sudo chmod a+x hap1.0/hap1.0.jar
# wget http://www.clustal.org/omega/clustalo-1.2.3-Ubuntu-x86_64
# sudo mv clustalo-1.2.3-Ubuntu-x86_64 hap1.0/clustalo
# sudo chmod a+x hap1.0/clustalo

working=`pwd`
PATH=$PATH:${working}/hap1.0:hap1.0

#  ** Noted issue with hap1.0.jar **   #
# hard coded config file has to change #
sudo rm ${working}/hap1.0/config.txt
echo ${working}/hap1.0/clustalo >> ${working}/hap1.0/config.txt
echo "Mode,none"      >> ${working}/hap1.0/config.txt
echo "Expand,false"   >> ${working}/hap1.0/config.txt
echo "HLA_DRB1,i1,i3" >> ${working}/hap1.0/config.txt
echo "HLA_DPB1,i1,i3" >> ${working}/hap1.0/config.txt
echo "HLA_DQB1,i1,i3" >> ${working}/hap1.0/config.txt
echo "PB_DRB1,i1,i3"  >> ${working}/hap1.0/config.txt
echo "PB_DPB1,i1,i3"  >> ${working}/hap1.0/config.txt
echo "PB_DQB1,i1,i3"  >> ${working}/hap1.0/config.txt

#  ** Noted issue with hap1.0.jar **   #
# Something odd with hap1.0.jar renaming
mv -i GFE_Submission gfe_submission

# Install GFE_Submission and launch
cd gfe_submission
perl Makefile.PL
make test
if [ "$?" != "0" ]; then
	exit $?
fi
sudo make install

# Run service
plackup -D -E deployment -s Starman -p 5000 -a bin/app.pl

# Install perl clients
cd ../client-perl
perl Makefile.PL
make test
if [ "$?" != "0" ]; then
	exit $?
fi
sudo make install

