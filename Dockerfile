FROM alpine:3.12

#We need to install git so we can clone the OpenRefine repo
RUN apk update && apk upgrade && apk add --no-cache git bash openjdk8

MAINTAINER tony.hirst@gmail.com
 
#Download a couple of required packages
RUN apk update && apk add --no-cache wget bash
 
#We can pass variables into the build process via --build-arg variables
#We name them inside the Dockerfile using ARG, optionally setting a default value
#ARG RELEASE=3.1
ARG RELEASE=3.4.1

#ENV vars are environment variables that get baked into the image
#We can pass an ARG value into a final image by assigning it to an ENV variable
ENV RELEASE=$RELEASE
 
#There's a handy discussion of ARG versus ENV here:
#https://vsupalov.com/docker-arg-vs-env/
 
#Download a distribution archive file
#Unpack the archive file and clear away the original download file
RUN wget --no-check-certificate https://github.com/OpenRefine/OpenRefine/releases/download/$RELEASE/openrefine-linux-$RELEASE.tar.gz && tar -xzf openrefine-linux-$RELEASE.tar.gz  && rm openrefine-linux-$RELEASE.tar.gz
 
#Create an OpenRefine project directory
RUN mkdir /mnt/refine
 
#Mount a Docker volume against the project directory
VOLUME /mnt/refine
 
#Expose the server port
EXPOSE 3333
 
#Create the state command.
#Note that the application is in a directory named after the release
#We use the environment variable to set the path correctly
CMD openrefine-$RELEASE/refine -i 0.0.0.0 -d /mnt/refine
