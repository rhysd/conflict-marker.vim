# Prerequisites

[Ruby](https://www.ruby-lang.org/) is required to run unit tests.

[Python](https://www.python.org/) is requried to take code coverage.

# How to run unit tests

This repository uses [vim-vspec](https://github.com/kana/vim-vspec) and [vim-flavor](https://github.com/kana/vim-flavor) to run unit tests. Run `bundle` command to install them locally.

Install all dependencies to run unit tests in `.bundle` directory.

```sh
bundle install --path=.bundle
bundle exec vim-flavor help
```

Run `vim-flavor` command via `bundle exec`:

```sh
bundle exec vim-flavor test
```

It runs all unit tests and output the results in terminal.

# How to take code coverage

This repository uses [covimerage](https://github.com/Vimjas/covimerage) to take code coverage.

Install covimerage in `./venv` directory.

```sh
python -m venv venv
source ./venv/bin/activate
pip install covimerage
covimerage --version
```

Run unit tests enabling profiling.

```sh
# Profile data will be stored in profile.txt
PROFILE_LOG=profile.txt bundle exec vim-flavor test
```

Extract code coverage data from profiling results.

```sh
covimerage write_coverage profile.txt
```

Output code coverage results with `coverage` command installed with Python.

```sh
# Show code coverage results in terminal
coverage report

# Output coverage data to XML file
coverage xml
```
