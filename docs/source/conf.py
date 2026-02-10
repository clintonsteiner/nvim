# Configuration file for the Sphinx documentation builder.
import os
import sys

# Add the parent directory to the path so we can import the modules
sys.path.insert(0, os.path.abspath('../../'))

# Project information
project = 'Neovim Configuration'
copyright = '2025, Clinton Steiner'
author = 'Clinton Steiner'
release = '0.1.0'
version = '0.1.0'

# General configuration
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.todo',
    'sphinx.ext.viewcode',
    'myst_parser',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# MyST configuration for Markdown support
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

# HTML output options
html_theme = 'furo'
html_static_path = ['_static']
html_theme_options = {
    "sidebar_hide_on": "lg",
    "light_css_variables": {
        "color-brand-primary": "#0066cc",
        "color-brand-content": "#0066cc",
    },
}

# Autodoc options
autodoc_typehints = 'description'
autodoc_member_order = 'bysource'

# TODOs
todo_include_todos = True
