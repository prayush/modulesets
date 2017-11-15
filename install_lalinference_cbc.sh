#!/bin/bash

export INSTALL_DIR=${1}

# Create pe directory where the installation will be
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}

# Download module sets for jhbuild
if [ ! -d ${INSTALL_DIR}/modulesets ]; then
  git clone git://github.com/vivienr/modulesets.git ${INSTALL_DIR}/modulesets
fi
cd ${INSTALL_DIR}/modulesets
git pull

# Download and install jhbuild
mkdir -p ${INSTALL_DIR}/src
if [ ! -d ${INSTALL_DIR}/src/jhbuild ]; then
  git clone git://git.gnome.org/jhbuild ${INSTALL_DIR}/src/jhbuild
  cd ${INSTALL_DIR}/src/jhbuild
  ./autogen.sh --prefix=${INSTALL_DIR}/.local/
  make
  make install
fi

# Set up jhbuild configuration files
mkdir -p ${INSTALL_DIR}/.config && cd ${INSTALL_DIR}/.config
if [ ! -e ${INSTALL_DIR}/.config/jhbuildrc ]; then
  ln -s ${INSTALL_DIR}/modulesets/jhbuildrc
fi

echo "prefix = '${INSTALL_DIR}/local/'" > ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "modulesets_dir = '${INSTALL_DIR}/modulesets'" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "checkoutroot = '${INSTALL_DIR}/src'" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "buildroot = '${INSTALL_DIR}/local/build'" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lal'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['laldetchar'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalframe'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalmetaio'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalxml'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalburst'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalpulsar'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalstochastic'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalinspiral'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalsimulation'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalinference'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['lalapps'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['glue'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['pylal'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "branches['ligo'] = (None,'lalinference_o2')" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "intel_executables = ['icc','icpc','ifort','mpiicc','mpiicpc','mpiifort','xiar']" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "from distutils.spawn import find_executable" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "def is_in_path(name):" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo '    """Check whether `name` is on PATH."""' >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "    return find_executable(name) is not None" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "if all([is_in_path(name) for name in intel_executables]):" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "   icc = True" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "del name" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "del intel_executables" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "os.environ['LAL_DATA_PATH'] = '$HOME/ROM_data/'" >> ${INSTALL_DIR}/.config/pe.jhbuildrc
echo "" >> ${INSTALL_DIR}/.config/pe.jhbuildrc

# Install lalsuite from anonymous repository
${INSTALL_DIR}/.local/bin/jhbuild -f ${INSTALL_DIR}/.config/jhbuildrc --no-interact tinderbox --output=$HOME/public_html/pe/build/ lalsuite

# Move bayeswave as it gets build in source directory
cp ${INSTALL_DIR}/src/bayeswave/src/bayeswave ${INSTALL_DIR}/local/bin/ 

## If needed, install additional packages:
# ${INSTALL_DIR}/.local/bin/jhbuild -f ${INSTALL_DIR}/.config/jhbuildrc run $SHELL --noprofile --norc
# pip install <package> --install-option="--prefix=${INSTALL_DIR}/local/"

# Create initisalisation script
echo '#!/bin/bash' > ${INSTALL_DIR}/lalinference_o2.sh
echo "${INSTALL_DIR}/.local/bin/jhbuild -f ${INSTALL_DIR}/.config/jhbuildrc run \$SHELL --noprofile --norc" >> ${INSTALL_DIR}/lalinference_o2.sh
chmod a+x ${INSTALL_DIR}/lalinference_o2.sh
