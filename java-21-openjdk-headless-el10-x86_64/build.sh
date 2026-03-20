#!/bin/bash

mkdir -p ${PREFIX}/x86_64-conda_el10-linux-gnu/sysroot
mkdir -p ${PREFIX}/x86_64-conda-linux-gnu/sysroot

if [[ -d usr/lib ]]; then
  if [[ ! -d lib ]]; then
    ln -s usr/lib lib
  fi
fi
if [[ -d usr/lib64 ]]; then
  if [[ ! -d lib64 ]]; then
    ln -s usr/lib64 lib64
  fi
fi

pushd ${PREFIX}/x86_64-conda_el10-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .

# These are a mixture of absolute links (-> /etc) or out-of-hierarchy
# (-> ../../../../etc) -- the latter should work but they are
# rewritten as absolute /etc values during test
symlinks=(
    usr/lib/jvm/java-21-openjdk/conf
    usr/lib/jvm/java-21-openjdk/lib/tzdb.dat
    usr/lib/jvm/java-21-openjdk/lib/security
)

# Update symlinks.
for sl in ${symlinks[*]} ; do
  link=$(readlink ${sl})
  unlink ${sl}
  ln -s ${PREFIX}/x86_64-conda-linux-gnu/sysroot${link} ${sl}
done

popd

pushd ${PREFIX}/x86_64-conda-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .

# Update symlinks.
for sl in ${symlinks[*]} ; do
  link=$(readlink ${sl})
  unlink ${sl}
  ln -s ${PREFIX}/x86_64-conda-linux-gnu/sysroot${link} ${sl}
done

popd

