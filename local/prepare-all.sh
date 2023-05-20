#!/bin/bash

set -x

bash install-dependency.sh

bash local/prepare-cmake.sh

bash local/prepare-boost.sh

bash local/prepare-googletest.sh

bash local/prepare-yaml.sh

