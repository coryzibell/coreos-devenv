echo ":: Ensuring that docker is running..."
sudo systemctl start docker

echo ":: Building docker containers..."

# Loop through the container definitions in .coreos-devenv/containers
# and build them or pull them if they exist.
REPOS=`find /home/core/sites/.coreos-devenv/containers/ -maxdepth 1 -type d -printf '%P '`

for REPO in $REPOS; do

	# Look in docker's public repository for an exact match, removing the
	# line describing the query used, which triggers a false positive.
	SEARCH_RESULT=`docker search coryzibell/$REPO | sed 1d | grep -o coryzibell/$REPO`

	if [[ -n $SEARCH_RESULT ]]; then
		echo "Found coryzibell/$REPO, pulling latest..."
		docker pull "coryzibell/$REPO"
	else
		echo "Didn't find coryzibell/$REPO, building it ourselves..."
		docker build -t coryzibell/$REPO /home/core/sites/.coreos-devenv/containers/$REPO/
	fi

done

echo ":: Starting mysql container..."

# Sometimes this is leftover from a previous run,
# but isn't running, so let's just remove it.
if [[ -n `docker ps | grep -o mysql56-standard` ]]; then
	docker stop mysql56-standard
fi
docker rm mysql56-standard

docker run \
	-v /home/core/sites/.coreos-databases/mysql:/var/lib/mysql \
	-p 3306:3306 \
	-e USERNAME="remote" \
	-e PASSWORD="blahblahblah" \
	-d \
	--name mysql56-standard \
	coryzibell/mysql56-standard

echo ":: Starting apache container..."

# Sometimes this is leftover from a previous run,
# but isn't running, so let's just remove it.
if [[ -n `docker ps | grep -o apache-php56-dynamic` ]]; then
	docker stop apache-php56-dynamic
fi
docker rm apache-php56-dynamic

docker run \
	-v /home/core/sites:/var/www \
	-p 80:80 \
	-p 443:443 \
	-d \
	--name apache-php56-dynamic \
	--link /mysql56-standard:db \
	coryzibell/apache-php56-dynamic
