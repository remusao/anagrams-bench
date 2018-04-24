#! /usr/bin/env python
# -*- coding: utf-8 -*-


from setuptools import setup, Extension
from Cython.Build import cythonize

ext = Extension(
    "anagram",
    [
        "anagram.pyx",
    ],
    define_macros=[
    ],
    include_dirs=[
    ],
    extra_compile_args=['-Ofast', '-march=native']
)

setup(
    name="anagram",
    version="0.1",
    description="Anagram benchmark",
    author="Rémi Berson",
    author_email="remi@cliqz.com",
    ext_modules=cythonize(ext, compiler_directives={
        'boundscheck': False,
        'wraparound': False,
        'nonecheck': False,
        'overflowcheck': False,
    })
)
