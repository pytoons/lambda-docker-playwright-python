# Define custom function directory
ARG FUNCTION_DIR="/function"

FROM public.ecr.aws/docker/library/ubuntu:jammy-20230126
# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

# install python
RUN apt-get update && apt-get install -y python3 python3-distutils python3-pip python3-apt

# Copy function code
RUN mkdir -p ${FUNCTION_DIR}
COPY app/* ${FUNCTION_DIR}

# Install the function's dependencies
RUN pip3 install \
    --target ${FUNCTION_DIR} \
        awslambdaric

WORKDIR ${FUNCTION_DIR}
COPY requirements.txt  .
RUN pip3 install -r requirements.txt --target "${FUNCTION_DIR}"
ENV PLAYWRIGHT_BROWSERS_PATH=0
RUN python3 -m playwright install-deps && python3 -m playwright install webkit

ENTRYPOINT [ "python3", "-m", "awslambdaric" ]

CMD [ "app.handler" ]