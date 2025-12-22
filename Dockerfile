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

ARG DHI_PYTHON_RUNTIME_TAG=3.12-alpine3.23
ARG DHI_PYTHON_BUILD_TAG=3.12-alpine3.23-dev

FROM dhi.io/python:${DHI_PYTHON_BUILD_TAG} AS builder

ENV LANG=en_US.UTF-8                                                                               \
    PYTHONDONTWRITEBYTECODE=1                                                                      \
    PYTHONUNBUFFERED=1                                                                             \
    VENV_PATH=/opt/venv                                                                            \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /robot

# Create isolated venv for Robot + libraries
RUN python -m venv "${VENV_PATH}"

COPY requirements/requirements.txt /robot/requirements.txt

# Install selected dependency set into the venv
RUN pip install --no-cache-dir -U -r /robot/requirements.txt                                       \
 && pip check

FROM dhi.io/python:${DHI_PYTHON_RUNTIME_TAG} AS runtime

ENV PYTHONUNBUFFERED=1                                                                             \
    VENV_PATH=/opt/venv                                                                            \
    PATH="/opt/venv/bin:$PATH"

# Robot writes output files by default; /tmp is typically writable for non-root users.
WORKDIR /tmp

COPY --from=builder /opt/venv /opt/venv

ENTRYPOINT ["robot"]
CMD ["--version"]
