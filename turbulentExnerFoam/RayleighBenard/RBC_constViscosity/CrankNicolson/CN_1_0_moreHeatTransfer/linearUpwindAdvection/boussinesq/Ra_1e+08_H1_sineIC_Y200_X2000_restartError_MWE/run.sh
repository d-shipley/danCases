#!/bin/bash -e

# version control
if [ if version.txt ]; then
    mv version.txt version_old.txt
fi
for i in $ATMOSFOAM $ATMOSFOAM_TOOLS $ATMOSFOAM_MULTIFLUID; do
    COMMIT_ID=$(git --git-dir=$i/.git log -n1)
    echo $i >> version.txt
    echo $COMMIT_ID >& version.txt
done

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log legends diags.dat gmt.history *.gif *.OpenFOAM

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 50
cp -r init_50/* 50

# Solve Boussinesq equations
boussinesqFoam >& log & sleep 0.01; tail -f log

# compare log files
gedit log log_Ra_1e+08_H1_sineIC_Y200_X2000 &