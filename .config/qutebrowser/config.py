# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

config.load_autoconfig()

# Load color theme
config.source("base16-qutebrowser/themes/base16-default-dark.config.py")
