# Prerequisites

[Python](https://www.python.org/) is requried to take code coverage.

# How to run unit tests

This repository uses [vim-themis](https://github.com/thinca/vim-themis) to run unit tests.

Clone vim-themis in your local

```sh
git clone https://github.com/thinca/vim-themis.git
```

Run `vim-flavor` command via `bundle exec`:
Execute `themis` command to run all unit tests

```sh
cd /path/to/conflict-marker.vim/test
/path/to/vim-themis/bin/themis *.vimspec
```

It runs all unit tests and outputs the results in terminal.

# How to take code coverage

This repository uses [covimerage](https://github.com/Vimjas/covimerage) to take code coverage.

Install covimerage in `./venv` directory.

```sh
python -m venv venv
source ./venv/bin/activate
pip install covimerage
covimerage --version
```

Run unit tests enabling profiling by setting `PROFILE_LOG` environment variable.

```sh
cd /path/to/conflict-marker.vim/test
PROFILE_LOG=profile.txt /path/to/vim-themis/bin/themis *.vimspec
```

It saves profiling results to `profile.txt`. Extract code coverage data from it using `covimerage`.

```sh
covimerage write_coverage profile.txt
```

Output code coverage results with `coverage` command which is part of standard Python toolchain.

```sh
# Show code coverage results in terminal
coverage report

# Output coverage data to XML file
coverage xml
```
