FROM dukegcb/openshift-shiny-verse:4.1.2
# RUN install2.r here
# RUN install2.r ggplot2
# RUN install2.r plotly

# copy src folder to srv/code
ADD ./src /srv/code

# Create persistent PVC mount directory and ensure writable
RUN mkdir -p /srv/data \
    && chmod -R 777 /srv/data \
    && chmod -R 777 /srv/code

# Pre-create log file with correct permissions
RUN touch /srv/data/shiny_logs.txt \
    && chmod 666 /srv/data/shiny_logs.txt

# Set the working directory
WORKDIR /srv/code

EXPOSE 3838
