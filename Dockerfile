FROM python:3.11.2-buster

ENV PYTHONUNBUFFERED=1
EXPOSE 8000

WORKDIR /usr/local/app
COPY . .

# SQL DB Driver
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends vim
#RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
#RUN apt-get install -y unixodbc-dev

RUN pip install poetry
RUN poetry config virtualenvs.create false
RUN poetry update

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
 && apt-get install -y --no-install-recommends openssh-server \
 && echo "$SSH_PASSWD" | chpasswd

COPY sshd_config /etc/ssh/
##COPY init.sh /usr/local/bin/

EXPOSE 8000 2222


RUN chmod 744 ./startup.sh

ENTRYPOINT ["./startup.sh"]
