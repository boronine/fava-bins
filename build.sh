#!/usr/bin/env sh

set -e

echo ">>>>>>>>>> Cleanup"
rm -rf venv-pyinstaller venv-build build dist cli.spec

echo ">>>>>>>>>> Set up venv for pyinstaller"
python3 -m venv venv-pyinstaller
. venv-pyinstaller/bin/activate
pip3 install pyinstaller
deactivate

echo ">>>>>>>>>> Set up venv for dependencies"
python3 -m venv venv-build
. venv-build/bin/activate
pip3 install "fava==$FAVA_VERSION"
pip3 freeze > VERSIONS
SITE_PACKAGES=$(python3 -c 'import site; print(site.getsitepackages()[0])')
deactivate

echo ">>>>>>>>>> Apply patches"
patch "$SITE_PACKAGES/fava/__init__.py" patches/fava-init.patch
patch "$SITE_PACKAGES/fava/util/__init__.py" patches/fava-util-init.patch
patch "$SITE_PACKAGES/beancount/__init__.py" patches/beancount-init.patch
echo "__version__ = '$FAVA_VERSION'" >> "$SITE_PACKAGES/fava/__init__.py"

echo ">>>>>>>>>> Generate"
. venv-pyinstaller/bin/activate
pyinstaller \
  --name "fava" \
  --onefile \
  --paths "$SITE_PACKAGES" \
  --hidden-import "beancount.ops.pad" \
  --hidden-import "beancount.ops.documents" \
  --hidden-import "beancount.ops.balance" \
  --add-data "$SITE_PACKAGES/fava:fava-src" \
  --add-data "$SITE_PACKAGES/beancount:beancount-src" \
  "$SITE_PACKAGES/fava/cli.py"
deactivate

echo ">>>>>>>>>> Sanity check: print version"
dist/fava --version

echo ">>>>>>>>>> Finalizing dist"
cp VERSIONS dist/VERSIONS
cp "$SITE_PACKAGES/fava-$FAVA_VERSION.dist-info/LICENSE" dist/LICENSE
echo "# Fava $FAVA_VERSION" >> dist/README
echo "" >> dist/README
echo "Project homepage: https://beancount.github.io/fava/" >> dist/README
echo "" >> dist/README
echo "Binaries built by Alexei Boronine <alexei@boronine.com> using: https://github.com/boronine/fava-bins" >> dist/README
