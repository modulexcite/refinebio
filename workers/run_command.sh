#!/bin/bash -e

# Script for executing Django management commands within a Docker container.


# This script should always run as if it were being called from
# the directory it lives in.
script_directory=`perl -e 'use File::Basename;
 use Cwd "abs_path";
 print dirname(abs_path(@ARGV[0]));' -- "$0"`
cd $script_directory

# However in order to give Docker access to all the code we have to
# move up a level
cd ..

# Ensure that postgres is running
if ! [[ $(docker ps --filter name=drdb -q) ]]; then
    echo "You must start Postgres first with:" >&2
    echo "./run_postgres.sh" >&2
    exit 1
fi

volume_directory="$script_directory/volume"
if [ ! -d "$volume_directory" ]; then
    mkdir $volume_directory
    chmod -R a+rwX $volume_directory
fi

source common.sh
HOST_IP=$(get_ip_address)
DB_HOST_IP=$(get_docker_db_ip_address)

chmod -R a+rwX $volume_directory

./prepare_image.sh -i smasher -s workers
image_name=ccdlstaging/dr_smasher

docker run \
       --add-host=database:$DB_HOST_IP \
       --add-host=nomad:$HOST_IP \
       --env-file workers/environments/local \
       --env AWS_ACCESS_KEY_ID \
       --env AWS_SECRET_ACCESS_KEY \
       --volume $volume_directory:/home/user/data_store \
       --link drdb:postgres \
       -it $image_name python3 manage.py "$@"
