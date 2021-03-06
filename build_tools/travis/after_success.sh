#!/bin/bash

# This script is meant to be called by the "after_success" step
# defined in ".travis.yml". In particular, we upload the wheels
# of the ARM64 architecture for the continuous deployment jobs.

set -e

# The wheels cannot be uploaded on PRs
if [[ $BUILD_WHEEL == true && $TRAVIS_EVENT_TYPE != pull_request ]]; then
    if [ $TRAVIS_EVENT_TYPE == cron ]; then
        ANACONDA_ORG="scipy-wheels-nightly"
        ANACONDA_TOKEN="$SCIKIT_LEARN_NIGHTLY_UPLOAD_TOKEN"
    else
        ANACONDA_ORG="scikit-learn-wheels-staging"
        ANACONDA_TOKEN="$SCIKIT_LEARN_STAGING_UPLOAD_TOKEN"
    fi

    pip install git+https://github.com/Anaconda-Server/anaconda-client

    # Force a replacement if the remote file already exists
    anaconda -t $ANACONDA_TOKEN upload --force -u $ANACONDA_ORG wheelhouse/*.whl
    echo "Index: https://pypi.anaconda.org/$ANACONDA_ORG/simple"
fi
