#!/bin/bash

mkdir -p ~/pe
cd ~/pe

git clone git://github.com/vivienr/modulesets.git ~/pe/modulesets
cd ~/pe/modulesets
git pull

mkdir -p ~/pe/src && git clone git://git.gnome.org/jhbuild ~/pe/src/jhbuild
cd ~/pe/src/jhbuild
./autogen.sh --prefix=~/pe/.local/
make
make install

mkdir -p ~/.config && cd ~/.config
ln -s ~/pe/modulesets/jhbuildrc
ln -s ~/pe/modulesets/pe.jhbuildrc

~/pe/.local/bin/jhbuild build lalsuite

cd ~/pe/src/lalsuite
git checkout -b lalinference_o2 origin/lalinference_o2
git pull

~/pe/.local/bin/jhbuild build lalsuite -n

## If needed, install additional packages:
# ~/pe/.local/bin/jhbuild -f ~/.config/jhbuildrc run $SHELL --noprofile --norc
# pip install <package> --install-option="--prefix=~/pe/local/"

# Create initisalisation script"
echo '#!/bin/bash' > ~/pe/lalinference_o2.sh
echo $HOME'/pe/.local/bin/jhbuild -f '$HOME'/.config/jhbuildrc run $SHELL --noprofile --norc' >> ~/pe/lalinference_o2.sh
chmod a+x ~/pe/lalinference_o2.sh
