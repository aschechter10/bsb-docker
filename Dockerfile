FROM python:3.9-slim

# Set working dir
WORKDIR /app

# install gcc and python3-dev
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev

# copy local buildstockbatch dir to container
COPY buildstockbatch /app/buildstockbatch

# copy local resstock dir to container
COPY resstock /app/resstock

# copy local openstudio dir to container
COPY OpenStudio-3.8.0+f953b6fcaf-Ubuntu-22.04-arm64 /app/OpenStudio-3.8.0+f953b6fcaf-Ubuntu-22.04-arm64

RUN chmod +x /app/OpenStudio-3.8.0+f953b6fcaf-Ubuntu-22.04-arm64/usr/local/openstudio-3.8.0/bin/openstudio

# set ENV var for openstudio
ENV OPENSTUDIO_EXE="/app/OpenStudio-3.8.0+f953b6fcaf-Ubuntu-22.04-arm64/usr/local/openstudio-3.8.0/bin/openstudio"

# set working dir to /app/buildstockbatch
WORKDIR /app/buildstockbatch

# install buildstockbatch
RUN python -m pip install -e .

# set working dir to test in resstock to run test file
WORKDIR /app/resstock/project_national

# make port 80 available to the world outside container
EXPOSE 80

# run yaml file to test resstock run 
CMD ["buildstock_local", "national_baseline.yml"]
