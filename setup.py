from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext as _build_ext
import glob
import platform
import subprocess
import os
import sys
import re
from pathlib import Path
from skbuild import setup
import skbuild

# See python/BuildStandalone.cmake, which builds Python libs
setup(
    name="kenlm",
    cmake_args=['-DBUILD_PYTHON_STANDALONE:BOOL=ON', "-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON"],
    packages=['kenlm'],
    package_dir={"kenlm": ""},
)
