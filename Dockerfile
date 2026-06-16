# syntax=docker/dockerfile:1
# MIT License
#
# Copyright (c) 2025 Róbert Malovec
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ARG DHI_PYTHON_BUILD_TAG=3.12-alpine3.24-dev

FROM dhi.io/python:${DHI_PYTHON_BUILD_TAG}

ENV LANG=en_US.UTF-8                                                                               \
    PYTHONDONTWRITEBYTECODE=1                                                                      \
    PYTHONUNBUFFERED=1                                                                             \
    VENV_PATH=/opt/venv                                                                            \
    PATH="/opt/venv/bin:/opt/jmeter/bin:$PATH"                                                     \
    JMETER_VERSION=5.6.3                                                                           \
    JMETER_REPO=https://dlcdn.apache.org//jmeter/binaries/apache-jmeter                            \
    JMETER_HOME=/opt/jmeter

WORKDIR /robot

# Script (kept only in builder stage)
COPY --chmod=0755 scripts/install-apk-from-file.sh /usr/local/bin/install-apk-from-file

# Install System deps
COPY requirements/apk.in /robot/requirements/apk.in
RUN /usr/local/bin/install-apk-from-file /robot/requirements/apk.in

# Install NPM packages
COPY requirements/npm.in /robot/requirements/npm.in
RUN npm install -g `cat /robot/requirements/npm.in`

# Install Python packages
RUN python -m venv "${VENV_PATH}"
COPY requirements/python.in /robot/requirements/python.in
RUN --mount=type=cache,target=/root/.cache/pip                                                    \
    pip install -U -r /robot/requirements/python.in                                               \
    && pip check

COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
