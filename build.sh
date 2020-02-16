UBUNTU_VERS="bionic"
SOGO_MAJOR=4
SOGO_MINOR=3

docker build . -t pagdot/sogo:latest -t pagdot/sogo:${SOGO_MAJOR} -t pagdot/sogo:${SOGO_MAJOR}.${SOGO_MINOR} --build-arg UBUNTU_VERS=${UBUNTU_VERS}