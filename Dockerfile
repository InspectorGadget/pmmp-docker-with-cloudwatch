FROM ubuntu:18.04

USER root

ARG AWS_REGION
ARG CW_LOG_GROUP_NAME

# Check if AWS_REGION is set
RUN if [ -z "$AWS_REGION" ]; then echo "AWS_REGION argument is missing"; exit 1; fi

# Add Python 3.5 PPA and install Python 3.5
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get purge --auto-remove -y software-properties-common \
    && apt-get install -y unzip curl python3.5 python3.5-dev python3.5-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy AWS CloudWatch Logs config file
COPY .awslogs/awslogs.conf /tmp/awslogs.conf

# Check if CW_LOG_GROUP_NAME is set and replace it in the config file accordingly. Default: pmmp-server-logs if ARG is not set.
RUN if [ -z "$CW_LOG_GROUP_NAME" ]; then sed -i "s/log_group_name =/log_group_name = pmmp-server-logs/g" /tmp/awslogs.conf; else sed -i "s/log_group_name =/log_group_name = $CW_LOG_GROUP_NAME/g" /tmp/awslogs.conf; fi

# Create cron.d directory to prevent error
RUN mkdir -p /etc/cron.d

# Install CloudWatch Agent
RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/AgentDependencies.tar.gz -O
RUN tar xvf AgentDependencies.tar.gz -C /tmp/
RUN python3.5 ./awslogs-agent-setup.py --region $AWS_REGION --dependency-path /tmp/AgentDependencies --configfile /tmp/awslogs.conf --python /usr/bin/python3.5 --non-interactive

# Sleep for 10 seconds before starting awslogs service, to ensure the volume is mounted (/data).  
CMD sleep 10 && service awslogs start && tail -f /var/log/awslogs.log